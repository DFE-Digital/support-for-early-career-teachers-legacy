# frozen_string_literal: true

class MentorMaterial < ApplicationRecord
  # TODO: hopefully remove some of those
  belongs_to :core_induction_programme, optional: true
  belongs_to :course_year, optional: true
  belongs_to :course_module, optional: true
  belongs_to :course_lesson, optional: true

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :content, presence: { message: "Enter content" }, length: { maximum: 2_000_000 }

  def get_core_induction_programme
    if course_lesson.present?
      course_lesson.course_year.core_induction_programme
    elsif course_module.present?
      course_module.course_year.core_induction_programme
    elsif course_year.present?
      course_year.core_induction_programme
    else
      core_induction_programme
    end
  end
end
