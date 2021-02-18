# frozen_string_literal: true

class CourseYear < ApplicationRecord
  include CourseYearHelper

  belongs_to :core_induction_programme, optional: true
  has_many :course_modules, dependent: :delete_all

  validates :title, presence: { message: "Enter a title" }
  validates :content, presence: { message: "Enter content" }

  def content_to_html
    Govspeak::Document.new(content, options: { allow_extra_quotes: true }).to_html
  end

  def modules_with_progress(user)
    ect_profile = user&.early_career_teacher_profile
    return course_modules unless ect_profile

    course_lessons = user_lessons_and_progresses(ect_profile)

    set_course_modules_progress(course_lessons)
  end

private

  def set_course_modules_progress(course_lessons)
    course_modules.map do |course_module|
      lessons = course_lessons.filter { |lesson| lesson.course_module_id == course_module.id }

      course_module.progress = if lessons.all? { |lesson| lesson.progress == "not_started" }
                                 "not_started"
                               elsif lessons.all? { |lesson| lesson.progress == "complete" }
                                 "complete"
                               else
                                 "in_progress"
                               end
      course_module
    end
  end
end
