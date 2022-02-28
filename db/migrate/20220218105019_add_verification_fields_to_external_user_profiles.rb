# frozen_string_literal: true

class AddVerificationFieldsToExternalUserProfiles < ActiveRecord::Migration[6.1]
  def change
    change_table :external_user_profiles, bulk: true do
      add_column :external_user_profiles, :verification_token, :string
      add_column :external_user_profiles, :verification_expires_at, :datetime
      add_column :external_user_profiles, :verified, :boolean, default: false
    end
  end
end
