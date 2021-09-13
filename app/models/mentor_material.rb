# frozen_string_literal: true

class MentorMaterial < ApplicationRecord
  include OrderHelper
  include TimeDescriptionHelper

  belongs_to :course_lesson
  has_one :course_module, through: :course_lesson
  has_one :course_year, through: :course_module
  delegate :core_induction_programme, to: :course_year

  has_many :mentor_material_parts, dependent: :destroy

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :completion_time_in_minutes, numericality: { greater_than: 0, allow_nil: true, message: "Enter a number greater than 0" }

  def mentor_material_parts_in_order
    preloaded_parts = mentor_material_parts.includes(:previous_mentor_material_part, :next_mentor_material_part)
    elements_in_order(elements: preloaded_parts, get_previous_element: :previous_mentor_material_part)
  end

  def duration_in_minutes_in_words
    minutes_to_words(completion_time_in_minutes)
  end

  def to_param
    (course_lesson.mentor_materials.find_index(self) + 1).to_s
  end
end
