# frozen_string_literal: true

class AddShowGuidanceSpeedbumpToMentorProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_profiles, :show_guidance_speedbump, :boolean, default: true
  end
end
