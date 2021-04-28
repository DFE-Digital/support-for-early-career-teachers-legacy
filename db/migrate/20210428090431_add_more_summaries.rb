# frozen_string_literal: true

class AddMoreSummaries < ActiveRecord::Migration[6.1]
  def change
    change_table :course_modules, bulk: true do |t|
      t.rename :content, :ect_summary
      t.text :mentor_summary, limit: 10_000
    end

    change_table :course_lessons, bulk: true do |t|
      t.text :ect_summary, limit: 10_000
      t.text :mentor_summary, limit: 10_000
    end
  end
end
