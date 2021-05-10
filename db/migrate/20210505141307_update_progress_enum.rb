# frozen_string_literal: true

class UpdateProgressEnum < ActiveRecord::Migration[6.1]
  def up
    change_table :course_lesson_progresses, bulk: true do |t|
      t.remove :progress, type: :string
      t.string :progress, default: "to_do"
    end
  end

  def down
    change_table :course_lesson_progresses, bulk: true do |t|
      t.remove :progress, type: :string
      t.string :progress, default: "not_started"
    end
  end
end
