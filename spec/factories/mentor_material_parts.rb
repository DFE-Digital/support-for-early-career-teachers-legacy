# frozen_string_literal: true

FactoryBot.define do
  factory :mentor_material_part do
    title { "Mentor material part" }
    content { "Test content" }
    mentor_material
  end
end
