# frozen_string_literal: true

require "csv"

class UserLoginDataReport
  def call
    CSV.generate do |csv|
      csv << headers

      users.each do |user|
        csv << [
          user.id,
          user.register_and_partner_id,
          user.last_sign_in_at,
          user.sign_in_count.to_i,
          user.early_career_teacher_profile&.id,
          user.mentor_profile&.id,
        ]
      end
    end
  end

private

  def headers
    %w[
      users_id
      users_register_and_partner_id
      users_last_sign_in_at
      users_sign_in_count
      early_career_teacher_profiles_id
      mentor_profiles_id
    ]
  end

  def users
    @users = User.all.includes(:mentor_profile, :early_career_teacher_profile)
  end
end
