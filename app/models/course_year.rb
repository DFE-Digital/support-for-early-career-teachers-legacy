# frozen_string_literal: true

class CourseYear < ApplicationRecord
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

    course_modules.map do |course_module|
      course_module.progress = course_module.user_progress(user)
      course_module
    end
  end
end
