# frozen_string_literal: true

FactoryBot.define do
  factory :course_module do
    title { "Test Course module" }
    ect_summary { "No content" }
    course_year { FactoryBot.create(:course_year, :with_cip) }

    trait :with_previous do
      after :build do |course_module|
        course_module.previous_module = FactoryBot.create(:course_module, course_year: course_module.course_year, title: "Test previous module")
      end
    end

    trait :with_lessons do
      transient do
        with_lessons_count { 3 }
        with_lessons_traits { [] }
      end

      after(:create) do |course_module, evaluator|
        create_list(:course_lesson, evaluator.with_lessons_count, *evaluator.with_lessons_traits, course_module: course_module)
      end
    end
  end
end
