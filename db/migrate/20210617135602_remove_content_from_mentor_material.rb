# frozen_string_literal: true

class RemoveContentFromMentorMaterial < ActiveRecord::Migration[6.1]
  def change
    remove_column :mentor_materials, :content, type: :string
  end
end
