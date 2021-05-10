# frozen_string_literal: true

FactoryBot.define do
  factory :course_year do
    title { "Test Course year" }
    content { "No content" }

    trait :with_cip do
      after(:create) do |year|
        cip = FactoryBot.create(:core_induction_programme,
                                course_year_one: year,
                                course_year_two: FactoryBot.create(:course_year))
        year.core_induction_programme_one = cip
      end
    end
  end
end
