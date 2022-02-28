# frozen_string_literal: true

module CipBreadcrumbHelper
  def home_breadcrumbs(user)
    [home_crumb(user)]
  end

  def course_year_breadcrumbs(user, year)
    array = []

    array << home_crumb(user)
    array << course_year_crumb(year, user) if editing_content?

    array
  end

  def course_module_breadcrumbs(user, course_module)
    array = []

    array << home_crumb(user)
    array << course_year_crumb(course_module.course_year, user)
    array << course_module_crumb(course_module) if editing_content?

    array
  end

  def course_lesson_breadcrumbs(user, course_lesson)
    array = []

    array << home_crumb(user)
    array << course_year_crumb(course_lesson.course_module.course_year, user) if course_lesson.course_module
    array << course_module_crumb(course_lesson.course_module) if course_lesson.course_module
    array << course_lesson_crumb(course_lesson) if editing_content?

    array
  end

  def mentor_material_breadcrumbs(user, mentor_material)
    lesson = mentor_material.course_lesson

    array = []

    array << home_crumb(user)
    array << course_year_crumb(lesson.course_module.course_year, user) if lesson.course_module
    array << course_module_crumb(lesson.course_module) if lesson.course_module
    array << mentor_material_crumb(mentor_material) if editing_content?

    array
  end

private

  def home_crumb(user)
    ["Home", home_path(user)]
  end

  def course_year_crumb(year, user)
    [year.title_for(user), year.present? ? year_path(year) : nil]
  end

  def course_module_crumb(course_module)
    [course_module.term_and_title, module_path(course_module)]
  end

  def course_lesson_crumb(course_lesson)
    if course_lesson.persisted?
      [course_lesson.title, lesson_path(course_lesson)]
    else
      ["Create lesson"]
    end
  end

  def mentor_material_crumb(mentor_material)
    if mentor_material.persisted?
      [mentor_material.title, mentor_material_path(mentor_material)]
    else
      ["Create mentor material"]
    end
  end

  def editing_content?
    action_name == "edit"
  end
end
