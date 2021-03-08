# frozen_string_literal: true

class CourseLesson < ApplicationRecord
  include OrderHelper

  belongs_to :course_module

  # We use previous_lesson_id to store the connections between lessons
  # The id telling us which lesson is next lives on the next lesson, where it is called 'previous_lesson_id'
  # That's why the foreign key is named contrary to the field name
  has_one :next_lesson, class_name: "CourseLesson", foreign_key: :previous_lesson_id
  belongs_to :previous_lesson, class_name: "CourseLesson", inverse_of: :next_lesson, optional: true

  has_many :course_lesson_parts

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :completion_time_in_minutes, numericality: { greater_than: 0, allow_nil: true, message: "Enter a number greater than 0" }

  attr_accessor :progress

  def course_lesson_parts_in_order
    preloaded_parts = course_lesson_parts.includes(:previous_lesson_part, :next_lesson_part)
    elements_in_order(elements: preloaded_parts, previous_method_name: :previous_lesson_part)
  end

  def duration_in_minutes_in_words
    hours = completion_time_in_minutes / 60
    minutes = completion_time_in_minutes % 60

    [].tap { |lesson_duration_string|
      lesson_duration_string << "#{hours} hour".pluralize(hours)       unless hours.zero?
      lesson_duration_string << "#{minutes} minute".pluralize(minutes) unless minutes.zero?
    }.join(" ")
  end
end
