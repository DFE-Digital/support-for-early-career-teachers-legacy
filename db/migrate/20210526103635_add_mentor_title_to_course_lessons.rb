# frozen_string_literal: true

class AddMentorTitleToCourseLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :course_lessons, :mentor_title, :string
  end
end
