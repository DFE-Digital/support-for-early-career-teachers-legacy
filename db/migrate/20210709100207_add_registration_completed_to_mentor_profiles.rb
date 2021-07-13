# frozen_string_literal: true

class AddRegistrationCompletedToMentorProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_profiles, :registration_completed, :boolean, default: false
  end
end
