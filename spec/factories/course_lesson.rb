# frozen_string_literal: true

FactoryBot.define do
  factory :course_lesson do
    title { "Test Course lesson" }
    course_module { FactoryBot.create(:course_module) }
  end
end
