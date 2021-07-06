# frozen_string_literal: true

FactoryBot.define do
  factory :course_year do
    title { "Test Course year" }
    content { "No content" }
    core_induction_programme { FactoryBot.create(:core_induction_programme) }
    position { 1 }

    after(:create) do |year|
      year.core_induction_programme.update!(course_year_one: year)
    end
  end
end
