# frozen_string_literal: true

class AddMentorTitleToCourseYears < ActiveRecord::Migration[6.1]
  def change
    add_column :course_years, :mentor_title, :string
    change_column_null :course_years, :content, true
  end
end
