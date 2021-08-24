# frozen_string_literal: true

FactoryBot.define do
  factory :cip_change_message do
    user
    association :original_cip, factory: :core_indiction_programme
    association :new_cip, factory: :core_indiction_programme
  end
end
