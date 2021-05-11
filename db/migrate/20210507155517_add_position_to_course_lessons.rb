# frozen_string_literal: true

class AddPositionToCourseLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :course_lessons, :position, :integer
  end
end
