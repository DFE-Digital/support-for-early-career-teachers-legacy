# frozen_string_literal: true

class CourseYear < ApplicationRecord
  include CourseLessonProgressHelper
  include OrderHelper

  has_one :core_induction_programme_one, class_name: "CoreInductionProgramme", foreign_key: :course_year_one_id
  has_one :core_induction_programme_two, class_name: "CoreInductionProgramme", foreign_key: :course_year_two_id
  has_many :course_modules, dependent: :delete_all
  has_many :mentor_materials

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :mentor_title, length: { maximum: 255 }
  validates :content, length: { maximum: 100_000 }

  def course_modules_in_order(modules_to_order = course_modules)
    preloaded_modules = modules_to_order.includes(:previous_module, :next_module)
    elements_in_order(elements: preloaded_modules, get_previous_element: :previous_module)
  end

  def autumn_modules_with_progress(user)
    modules_with_progress(user, course_modules.autumn)
  end

  def spring_modules_with_progress(user)
    modules_with_progress(user, course_modules.spring)
  end

  def summer_modules_with_progress(user)
    modules_with_progress(user, course_modules.summer)
  end

  def modules_with_progress(user, modules_to_order = course_modules)
    modules_in_order = course_modules_in_order(modules_to_order)
    ect_profile = user&.early_career_teacher_profile
    return modules_in_order unless ect_profile

    course_lessons = CourseLesson.with_self_study_materials.where(course_module: modules_in_order)
    lessons_with_progresses = get_user_lessons_and_progresses(ect_profile, course_lessons)

    compute_user_course_module_progress(lessons_with_progresses, modules_in_order)
  end

  def core_induction_programme
    core_induction_programme_one || core_induction_programme_two
  end

  def title_for(user)
    return title if mentor_title.blank?

    user.mentor? ? mentor_title : title
  end

  def to_param
    "year-#{self == core_induction_programme.course_year_one ? '1' : '2'}"
  end

private

  def compute_user_course_module_progress(lessons_with_progresses, modules_in_order)
    modules_in_order.map do |course_module|
      lessons = lessons_with_progresses.filter { |lesson| lesson.course_module_id == course_module.id }
      course_module.progress = course_module_progress_status(lessons)
      course_module
    end
  end

  def course_module_progress_status(lessons)
    if lessons.all? { |lesson| lesson.progress == "to_do" }
      "to_do"
    elsif lessons.all? { |lesson| lesson.progress == "complete" }
      "complete"
    else
      "in_progress"
    end
  end
end
