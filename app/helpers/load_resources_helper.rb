# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module LoadResourcesHelper
  def load_core_induction_programme_from_params
    return @core_induction_programme if @core_induction_programme

    slug = params[:cip_id] || params[:id]
    @core_induction_programme = CoreInductionProgramme.find_by slug: slug

    raise ActionController::RoutingError, "Core Induction Programme not found" unless @core_induction_programme

    @core_induction_programme
  end

  def load_course_year_from_params
    return @course_year if @course_year

    load_core_induction_programme_from_params

    match = (params[:year_id] || params[:id]).match(/year-(\d+)/)
    @course_year = @core_induction_programme.course_years[match[1].to_i - 1]

    raise ActionController::RoutingError, "Year not found" unless @course_year

    @course_year
  end

  def load_course_module_from_params
    return @course_module if @course_module

    load_course_year_from_params

    match = (params[:module_id] || params[:id]).match(/(autumn|spring|summer)-(\d+)/)

    index = match[2].to_i - 1
    term_modules = @course_year.course_modules.public_send(match[1])
    @course_module = @course_year.course_modules_in_order(term_modules)[index]

    raise ActionController::RoutingError, "module not found" unless @course_module

    @course_module
  end

  def load_course_lesson_from_params
    return @course_lesson if @course_lesson

    load_course_module_from_params
    match = (params[:lesson_id] || params[:id]).match(/topic-(\d+)/)
    @course_lesson = @course_module.course_lessons[match[1].to_i - 1]

    raise ActionController::RoutingError, "lesson not found" unless @course_lesson

    @course_lesson
  end

  def load_course_lesson_part_from_params
    return @course_lesson_part if @course_lesson_part

    load_course_lesson_from_params

    match = (params[:lesson_part_id] || params[:id]).match(/part-(\d+)/)
    @course_lesson_part = @course_lesson.course_lesson_parts_in_order[match[1].to_i - 1]

    raise ActionController::RoutingError, "lesson part not found" unless @course_lesson_part

    @course_lesson_part
  end

  def load_mentor_material_from_params
    return @mentor_material if @mentor_material

    load_course_lesson_from_params

    id = (params[:mentor_material_id] || params[:id]).to_i - 1
    @mentor_material = @course_lesson.mentor_materials[id]

    raise ActionController::RoutingError, "mentor material not found" unless @mentor_material

    @mentor_material
  end

  def load_mentor_material_part_from_params
    return @mentor_material_part if @mentor_material_part

    load_mentor_material_from_params

    match = (params[:mentor_material_part_id] || params[:id]).match(/part-(\d+)/)
    id = match[1].to_i - 1
    @mentor_material_part = @mentor_material.mentor_material_parts_in_order[id]

    raise ActionController::RoutingError, "mentor material part not found" unless @mentor_material_part

    @mentor_material_part
  end
end
# rubocop:enable Rails/HelperInstanceVariable
