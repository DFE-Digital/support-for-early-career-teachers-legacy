# frozen_string_literal: true

# This helper metaprograms in a bunch of path helper methods that went away when
# we switched to using nested resources that we wanted to keep for convenience
# and for brevity. Effectively what it does is define methods like this:
#
#   def module_path(course_module = @course_module)
#     cip_year_module_path(course_module.course_year.core_induction_programme, course_module.course_year, course_module)
#   end
#
# That's just for module paths, which are three levels deep - mentor material
# parts are six levels deep, so as you can image get pretty messy!
module PathHelper
  def years_path(*args)
    cip_years_path(*args)
  end

  models = {
    cip: "core_induction_programme",
    year: "course_year",
    module: "course_module",
    lesson: "course_lesson",
    lesson_part: "course_lesson_part",
    mentor_material: "mentor_material",
    mentor_material_part: "mentor_material_part",
  }

  parents = {
    year: "cip",
    module: "year",
    lesson: "module",
    lesson_part: "lesson",
    mentor_material: "lesson",
    mentor_material_part: "mentor_material",
  }

  get_name = lambda do |name, helper_obj|
    to_prepend = helper_obj.key?(:prepend) ? helper_obj[:prepend] + "_" : ""
    to_append = helper_obj.key?(:append) ? "_" + helper_obj[:append] : ""
    "#{to_prepend}#{name}#{to_append}_path"
  end

  [
    { name: "year" },
    { name: "year", prepend: "edit" },
    { name: "module" },
    { name: "module", prepend: "edit" },
    { name: "lesson" },
    { name: "lesson", prepend: "edit" },
    { name: "lesson_part" },
    { name: "lesson_part", prepend: "edit" },
    { name: "lesson_part", append: "split" },
    { name: "lesson_part", append: "show_delete" },
    { name: "lesson_part", append: "update_progress" },
    { name: "mentor_material" },
    { name: "mentor_material", prepend: "edit" },
    { name: "mentor_material_part" },
    { name: "mentor_material_part", prepend: "edit" },
    { name: "mentor_material_part", append: "split" },
    { name: "mentor_material_part", append: "show_delete" },
  ].each do |helper|
    define_method get_name.call(helper[:name], helper) do |resource = nil|
      # use instance variable if nothing passed in - mostly done by forms
      resource ||= instance_variable_get("@#{models[helper[:name].to_sym]}")

      # builds an array from resource name like ["module", "year", "cip"]
      parts = [helper[:name]]
      parts.push(parents[parts.last.to_sym]) while parents[parts.last.to_sym]

      # builds arguments from resource like [module, module.year, module.year.cip]
      args = [resource]
      parts[1..].each { |part| args.unshift(args.first.public_send(models[part.to_sym])) }

      public_send(get_name.call(parts.reverse.join("_"), helper), *args)
    end
  end
end
