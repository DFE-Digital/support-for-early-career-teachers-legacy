# frozen_string_literal: true

class MentorMaterial < ApplicationRecord
  include OrderHelper

  # TODO: hopefully remove some of those
  belongs_to :core_induction_programme, optional: true
  belongs_to :course_year, optional: true
  belongs_to :course_module, optional: true
  belongs_to :course_lesson

  has_many :mentor_material_parts

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }

  def get_core_induction_programme
    if course_lesson.present?
      course_lesson.course_year.core_induction_programme
    elsif course_module.present?
      course_module.course_year.core_induction_programme
    elsif course_year.present?
      course_year.core_induction_programme
    else
      core_induction_programme
    end
  end

  def mentor_material_parts_in_order
    preloaded_parts = mentor_material_parts.includes(:previous_mentor_material_part, :next_mentor_material_part)
    elements_in_order(elements: preloaded_parts, get_previous_element: :previous_mentor_material_part)
  end

  def to_param
    (course_lesson.mentor_materials.find_index(self) + 1).to_s
  end
end
