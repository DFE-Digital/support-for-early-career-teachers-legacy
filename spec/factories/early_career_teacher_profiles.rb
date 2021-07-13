# frozen_string_literal: true

FactoryBot.define do
  factory :early_career_teacher_profile do
    user
    core_induction_programme
    induction_programme_choice { "core_induction_programme" }
    registration_completed { true }
  end
end
