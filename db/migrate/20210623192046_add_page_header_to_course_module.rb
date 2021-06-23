# frozen_string_literal: true

class AddPageHeaderToCourseModule < ActiveRecord::Migration[6.1]
  def change
    add_column :course_modules, :page_header, :string
  end
end
