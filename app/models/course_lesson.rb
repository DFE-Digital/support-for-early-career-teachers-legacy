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
  validates :completion_time_in_minutes, numericality: { greater_than_or_equal_to: 1, allow_nil: true, message: "Enter a number greater than 0" }

  attr_accessor :progress

  def course_lesson_parts_in_order
    preloaded_parts = course_lesson_parts.includes(:previous_lesson_part, :next_lesson_part)
    elements_in_order(elements: preloaded_parts, previous_method_name: :previous_lesson_part)
  end

  def convert_minutes_to_words(minutes_in_time)
    number_of_hours = minutes_in_time / 60
    number_of_minutes = minutes_in_time % 60

    hour = "hour".pluralize(number_of_hours)
    minute = "minute".pluralize(number_of_minutes)

    if number_of_hours.positive?
      "#{number_of_hours} #{hour} #{number_of_minutes} #{minute}"
    else
      "#{number_of_minutes} #{minute}"
    end
  end
end
