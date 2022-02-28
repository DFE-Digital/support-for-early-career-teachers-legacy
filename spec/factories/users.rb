# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    account_created { true }

    trait :admin do
      admin_profile { build(:admin_profile) }
      login_token { Faker::Alphanumeric.alpha(number: 10) }
      login_token_valid_until { 1.hour.from_now }
    end

    transient do
      core_induction_programme { false }
      cohort_year { nil }
      registration_completed { nil }
      profile_attributes do
        {}.tap do |attrs|
          attrs.merge!(core_induction_programme: core_induction_programme) if core_induction_programme
          attrs.merge!(cohort_year: cohort_year) if cohort_year
          attrs.merge!(registration_completed: registration_completed) unless registration_completed.nil?
        end
      end
    end

    trait :induction_coordinator do
      induction_coordinator_profile { build(:induction_coordinator_profile, **profile_attributes) }
    end

    trait :early_career_teacher do
      early_career_teacher_profile { build(:early_career_teacher_profile, **profile_attributes) }
    end

    trait :mentor do
      mentor_profile { build(:mentor_profile) }
    end

    trait :external_user do
      external_user_profile { build(:external_user_profile) }
    end
  end
end
