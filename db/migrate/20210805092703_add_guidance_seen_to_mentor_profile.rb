# frozen_string_literal: true

class AddGuidanceSeenToMentorProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_profiles, :guidance_seen, :boolean, default: false
  end
end
