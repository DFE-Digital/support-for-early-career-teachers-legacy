# frozen_string_literal: true

class CourseLessonProgress < ApplicationRecord
  enum progress: {
    to_do: "to_do",
    in_progress: "in_progress",
    complete: "complete",
  }

  validates :progress, presence: { message: "Select if you have finished and understood the session" }

  belongs_to :course_lesson
  belongs_to :early_career_teacher_profile
  has_one :user, through: :early_career_teacher_profile

  validates :course_lesson_id, uniqueness: { scope: :early_career_teacher_profile_id }
end
