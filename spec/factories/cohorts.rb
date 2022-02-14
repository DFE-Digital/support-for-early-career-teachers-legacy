# frozen_string_literal: true

FactoryBot.define do
  factory :cohort do
    initialize_with { Cohort.find_or_create_by(start_year: start_year) }
    start_year { Faker::Date.between(from: "2020-01-01", to: "2099-12-31").year }
  end
end
