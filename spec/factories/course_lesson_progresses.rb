# frozen_string_literal: true

FactoryBot.define do
  factory :course_lesson_progress do
    progress { "to_do" }
    course_lesson
    early_career_teacher_profile
  end
end
