# frozen_string_literal: true

FactoryBot.define do
  factory :external_user_profile do
    user
  end

  trait :sent_verification_link do
    verification_expires_at { 1.hour.from_now }
    verification_token { Faker::Alphanumeric.alpha(number: 10) }
  end

  trait :expired_verification_link do
    verification_expires_at { 1.hour.ago }
    verification_token { Faker::Alphanumeric.alpha(number: 10) }
  end
end
