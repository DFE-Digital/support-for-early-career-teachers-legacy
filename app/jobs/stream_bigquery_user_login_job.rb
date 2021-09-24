# frozen_string_literal: true

class StreamBigqueryUserLoginJob < ApplicationJob
  def perform(user)
    bigquery = Google::Cloud::Bigquery.new
    dataset = bigquery.dataset "engage_and_learn", skip_lookup: true
    table = dataset.table "user_logins_#{Rails.env.downcase}", skip_lookup: true

    rows = [
      {
        "users_id" => user.id,
        "users_register_and_partner_id" => user.register_and_partner_id,
        "users_last_sign_in_at" => user.last_sign_in_at,
        "users_sign_in_count" => user.sign_in_count,
        "early_career_teacher_profiles_id" => user.early_career_teacher_profile&.id,
        "mentor_profiles_id" => user.mentor_profile&.id,
      },
    ]

    table.insert rows
  end
end
