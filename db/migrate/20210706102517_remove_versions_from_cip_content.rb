# frozen_string_literal: true

class RemoveVersionsFromCipContent < ActiveRecord::Migration[6.1]
  def change
    remove_column :course_years, :version, :integer, null: false, default: 1
    remove_column :course_modules, :version, :integer, null: false, default: 1
    remove_column :course_lessons, :version, :integer, null: false, default: 1
  end
end
