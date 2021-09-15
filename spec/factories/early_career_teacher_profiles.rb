# frozen_string_literal: true

FactoryBot.define do
  factory :early_career_teacher_profile do
    user
    core_induction_programme
    induction_programme_choice { "core_induction_programme" }
    registration_completed { true }
    guidance_seen { false }
    cohort { build(:cohort, **cohort_attributes) }

    transient do
      cohort_year { nil }
      cohort_attributes do
        {}.tap do |attrs|
          attrs.merge!(start_year: cohort_year) if cohort_year
        end
      end
    end
  end
end
