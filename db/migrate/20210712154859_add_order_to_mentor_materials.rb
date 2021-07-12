# frozen_string_literal: true

class AddOrderToMentorMaterials < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_materials, :position, :integer, default: 1
    MentorMaterial.reset_column_information
    CourseLesson.all.each do |lesson|
      lesson.mentor_materials.each_with_index do |mentor_material, index|
        mentor_material.update!(position: index + 1)
      end
    end
  end
end
