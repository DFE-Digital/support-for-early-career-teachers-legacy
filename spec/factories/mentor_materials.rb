# frozen_string_literal: true

FactoryBot.define do
  factory :mentor_material do
    title { "Test Mentor materials" }

    course_lesson { FactoryBot.create(:course_lesson) }

    trait :with_mentor_material_part do
      after(:create) do |material|
        material.mentor_material_parts = [MentorMaterialPart.create!(mentor_material: material, content: "No content", title: "Title")]
      end
    end
  end
end
