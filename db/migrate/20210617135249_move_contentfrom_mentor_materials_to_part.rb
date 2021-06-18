# frozen_string_literal: true

class MoveContentfromMentorMaterialsToPart < ActiveRecord::Migration[6.1]
  def up
    MentorMaterial.all.each do |material|
      MentorMaterialPart.create!(title: "Mentor materials content", content: material.content, mentor_material: material)
    end
  end

  def down
    MentorMaterial.all.each do |material|
      contents = material.mentor_material_parts_in_order.map(&:content)
      material.update!(content: contents.join("\n\n"))
    end
    MentorMaterialPart.delete_all
  end
end
