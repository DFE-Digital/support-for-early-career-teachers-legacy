# frozen_string_literal: true

class AddRegistrationCompletedToEarlyCareerTeacherProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :early_career_teacher_profiles, :registration_completed, :boolean, default: false
  end
end
