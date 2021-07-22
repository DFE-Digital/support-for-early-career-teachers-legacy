# frozen_string_literal: true

class AddCompletionTimeToMentorMaterials < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_materials, :completion_time_in_minutes, :integer, null: true
  end
end
