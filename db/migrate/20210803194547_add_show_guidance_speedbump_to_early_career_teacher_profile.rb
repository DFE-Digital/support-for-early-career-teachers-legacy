# frozen_string_literal: true

class AddShowGuidanceSpeedbumpToEarlyCareerTeacherProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :early_career_teacher_profiles, :show_guidance_speedbump, :boolean, default: true
  end
end
