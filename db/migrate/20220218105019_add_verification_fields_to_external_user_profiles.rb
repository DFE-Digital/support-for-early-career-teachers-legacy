class AddVerificationFieldsToExternalUserProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :external_user_profiles, :verification_token, :string
    add_column :external_user_profiles, :verification_expires_at, :datetime
    add_column :external_user_profiles, :verified, :boolean, default: false
  end
end
