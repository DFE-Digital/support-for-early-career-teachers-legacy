# frozen_string_literal: true

class EnsureMentorMaterialsPointAtLessons < ActiveRecord::Migration[6.1]
  def change
    MentorMaterial.where(course_lessons: nil).destroy_all
    remove_reference :mentor_materials, :core_induction_programme
    remove_reference :mentor_materials, :course_year
    remove_reference :mentor_materials, :course_module
    change_column :mentor_materials, :course_lesson_id, :uuid, null: false, foreign_key: true
  end
end
