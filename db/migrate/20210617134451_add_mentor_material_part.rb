# frozen_string_literal: true

class AddMentorMaterialPart < ActiveRecord::Migration[6.1]
  def change
    create_table :mentor_material_parts do |t|
      t.timestamps

      t.column :title, :string, null: false
      t.column :content, :text, null: false, limit: 100_000

      t.references :previous_mentor_material_part, null: true, foreign_key: { to_table: :mentor_material_parts }, type: :uuid
      t.references :mentor_material, null: false, foreign_key: true, type: :uuid
    end
  end
end
