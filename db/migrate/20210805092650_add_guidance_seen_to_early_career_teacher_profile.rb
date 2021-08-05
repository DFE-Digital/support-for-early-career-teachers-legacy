# frozen_string_literal: true

class AddGuidanceSeenToEarlyCareerTeacherProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :early_career_teacher_profiles, :guidance_seen, :boolean, default: false
  end
end
