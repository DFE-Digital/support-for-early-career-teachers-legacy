# frozen_string_literal: true

class MentorMaterialPart < ApplicationRecord
  belongs_to :mentor_material

  has_one :next_mentor_material_part, class_name: "MentorMaterialPart", foreign_key: :previous_mentor_material_part_id, dependent: :nullify
  belongs_to :previous_mentor_material_part, class_name: "MentorMaterialPart", inverse_of: :next_mentor_material_part, optional: true

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :content, presence: { message: "Enter content" }, length: { maximum: 100_000 }

  def to_param
    "part-" + (mentor_material.mentor_material_parts_in_order.find_index(self) + 1).to_s
  end
end
