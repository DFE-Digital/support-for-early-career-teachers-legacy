# frozen_string_literal: true

class AddMentorMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :mentor_materials, id: :uuid do |t|
      t.column :title, :string, null: false
      t.column :content, :text, null: false, limit: 2_000_000
      t.timestamps

      t.references :core_induction_programme, null: true, foreign_key: true, type: :uuid
      t.references :course_year, null: true, foreign_key: true, type: :uuid
      t.references :course_module, null: true, foreign_key: true, type: :uuid
      t.references :course_lesson, null: true, foreign_key: true, type: :uuid
    end
  end
end
