# frozen_string_literal: true

class CourseYear < ApplicationRecord
  include CourseYearHelper
  include OrderHelper

  belongs_to :core_induction_programme, optional: true
  has_many :course_modules, dependent: :delete_all

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :content, presence: { message: "Enter content" }, length: { maximum: 100_000 }

  def content_to_html
    Govspeak::Document.new(content, options: { allow_extra_quotes: true }).to_html
  end

  def modules_with_progress(user)
    modules_in_order = course_modules_in_order
    ect_profile = user&.early_career_teacher_profile
    return modules_in_order unless ect_profile

    set_user_course_module_progresses(get_user_lessons_and_progresses(ect_profile))
  end

  def course_modules_in_order
    preloaded_modules = course_modules.includes(:previous_module, :next_module)
    elements_in_order(elements: preloaded_modules, previous_method_name: :previous_module)
  end

private

  def set_user_course_module_progresses(course_lessons)
    course_modules.map do |course_module|
      lessons = course_lessons.filter { |lesson| lesson.course_module_id == course_module.id }
      course_module.progress = course_module_progress_status(lessons)
      course_module
    end
  end

  def course_module_progress_status(lessons)
    if lessons.all? { |lesson| lesson.progress == "not_started" }
      "not_started"
    elsif lessons.all? { |lesson| lesson.progress == "complete" }
      "complete"
    else
      "in_progress"
    end
  end
end
