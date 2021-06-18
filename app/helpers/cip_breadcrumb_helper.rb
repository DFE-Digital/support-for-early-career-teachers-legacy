# frozen_string_literal: true

module CipBreadcrumbHelper
  def home_breadcrumbs(user)
    [home_crumb(user)]
  end

  def course_year_breadcrumbs(user, year)
    [
      home_crumb(user),
      end_crumb(course_year_crumb(year, user)),
    ]
  end

  def course_module_breadcrumbs(user, course_module)
    module_crumb = course_module_crumb(course_module)
    [
      home_crumb(user),
      course_year_crumb(course_module.course_year, user),
      end_crumb(module_crumb),
    ]
  end

  def course_lesson_breadcrumbs(user, course_lesson)
    array = []

    array << home_crumb(user)
    array << course_year_crumb(course_lesson.course_module.course_year, user) if course_lesson.course_module
    array << course_module_crumb(course_lesson.course_module) if course_lesson.course_module
    array << end_crumb(course_lesson_crumb(course_lesson))

    array
  end

  def mentor_material_breadcrumbs(user, mentor_material)
    lesson = mentor_material.course_lesson

    array = []

    array << home_crumb(user)
    array << course_year_crumb(lesson.course_module.course_year, user) if lesson.course_module
    array << course_module_crumb(lesson.course_module) if lesson.course_module
    array << end_crumb(mentor_material_crumb(mentor_material))

    array
  end

private

  def home_crumb(user)
    ["Home", user ? dashboard_path : cip_path]
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

  def end_crumb(crumb)
    action_name == "show" ? crumb[0] : crumb
  end
end
