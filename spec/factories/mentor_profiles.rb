# frozen_string_literal: true

FactoryBot.define do
  factory :mentor_profile do
    user
    core_induction_programme
    induction_programme_choice { "core_induction_programme" }
    registration_completed { true }
  end
end
