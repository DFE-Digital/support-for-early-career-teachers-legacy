# frozen_string_literal: true

FactoryBot.define do
  factory :course_year do
    title { "Test Course year" }
    content { "No content" }

    trait :with_cip do
      after(:create) do |year|
        cip = FactoryBot.create(:core_induction_programme,
                                course_year_one: year)
        year.core_induction_programme = cip
      end
    end
  end
end
