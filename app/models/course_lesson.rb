# frozen_string_literal: true

class CourseLesson < ApplicationRecord
  include OrderHelper
  include TimeDescriptionHelper

  belongs_to :course_module
  acts_as_list scope: :course_module

  has_one :course_year, through: :course_module

  # We use previous_lesson_id to store the connections between lessons
  # The id telling us which lesson is next lives on the next lesson, where it is called 'previous_lesson_id'
  # That's why the foreign key is named contrary to the field name
  has_one :next_lesson, class_name: "CourseLesson", foreign_key: :previous_lesson_id
  belongs_to :previous_lesson, class_name: "CourseLesson", inverse_of: :next_lesson, optional: true

  has_many :course_lesson_parts
  has_many :mentor_materials, -> { order(position: :asc) }

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :mentor_title, length: { maximum: 255 }
  validates :completion_time_in_minutes, numericality: { greater_than: 0, allow_nil: true, message: "Enter a number greater than 0" }

  attr_accessor :progress, :new_position

  after_commit :update_to_new_position

  scope :with_self_study_materials, -> { includes(:course_lesson_parts).joins(:course_lesson_parts) }

  def course_lesson_parts_in_order
    preloaded_parts = course_lesson_parts.includes(:previous_lesson_part, :next_lesson_part)
    elements_in_order(elements: preloaded_parts, get_previous_element: :previous_lesson_part)
  end

  def duration_in_minutes_in_words
    minutes_to_words(completion_time_in_minutes)
  end

  def module_and_lesson
    "#{course_module.title}: #{title}"
  end

  def title_for(user)
    return title if mentor_title.blank?

    user.mentor? ? mentor_title : title
  end

  def teacher_standards_for(user)
    return ect_teacher_standards if mentor_teacher_standards.blank?

    user.mentor? ? mentor_teacher_standards : ect_teacher_standards
  end

  def to_param
    "topic-" + (course_module.course_lessons.find_index(self) + 1).to_s
  end

private

  def update_to_new_position
    if new_position.present?
      insert_at(new_position.to_i)
    end
  end
end
