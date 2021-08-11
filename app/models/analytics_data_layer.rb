# frozen_string_literal: true

##
# The AnalyticsDataLayer enables pushing key value pairs to the Google Analytics `dataLayer`
# The app/helpers/application_helper.rb sets up an instance of this class named "data_layer"
# The js variable dataLayer is initialised in app/views/layouts/_application.html.erb and by default will
# be populated with `current_user` info and also the URN of any school in the view assigns hash.
# To add any additional view specific key/value pairs from any view:
#
#   <% data_layer.add(mykey: "my value", my_hash: { a: 1, b: 2}) %>
#
# The collected data is split into an array of key value pairs when rendered in the layout using .to_json
#
# e.g.
# <script>
#   dataLayer = [{"mykey":"my value"},{"my_hash":{"a":1,"b":2}}];
# </script>
#

class AnalyticsDataLayer
  attr_accessor :analytics_data

  def initialize
    @analytics_data = {}
  end

  def add(data = {})
    @analytics_data.merge!(data)
  end

  def add_user_info(user)
    @analytics_data[:userType] = user.user_description if user
    @analytics_data[:userRegisterAndPartnerId] = user.register_and_partner_id if user
    @analytics_data[:userCoreInductionProgramme] = user.core_induction_programme.name if user&.core_induction_programme
    @analytics_data[:cohortStartYear] = user.cohort.start_year if user&.participant?
  end

  def add_cip_info(cip)
    @analytics_data[:cip] = cip.name if cip
  end

  def add_year_info(year)
    add_cip_info(year.core_induction_programme) if year
    @analytics_data[:cipYear] = "Year #{year.position}" if year
  end

  def add_module_info(course_module)
    add_year_info(course_module.course_year) if course_module
    @analytics_data[:cipModule] = course_module.title if course_module
  end

  def add_lesson_info(course_lesson)
    add_module_info(course_lesson.course_module) if course_lesson
    @analytics_data[:cipLesson] = course_lesson.title if course_lesson
  end

  def add_lesson_part_info(course_lesson_part)
    add_lesson_info(course_lesson_part.course_lesson) if course_lesson_part
    @analytics_data[:cipLessonPart] = course_lesson_part.title if course_lesson_part
  end

  def add_mentor_material_info(mentor_material)
    add_lesson_info(mentor_material.course_lesson) if mentor_material
    @analytics_data[:cipMentorMaterial] = mentor_material.title if mentor_material
  end

  def add_mentor_material_part_info(mentor_material_part)
    add_mentor_material_info(mentor_material_part.mentor_material) if mentor_material_part
    @analytics_data[:cipMentorMaterialPart] = mentor_material_part.title if mentor_material_part
  end

  def as_json(_opts = nil)
    analytics_data.map { |k, v| { k => v } }
  end
end
