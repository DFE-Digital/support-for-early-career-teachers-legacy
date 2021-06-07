# frozen_string_literal: true

class AddTeacherStandardsToLessons < ActiveRecord::Migration[6.1]
  def change
    change_table :course_lessons, bulk: true do |t|
      t.string :ect_teacher_standards, null: true
      t.string :mentor_teacher_standards, null: true
    end
  end
end
