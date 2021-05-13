# frozen_string_literal: true

class CourseLesson < ApplicationRecord
  include OrderHelper

  belongs_to :course_module
  acts_as_list scope: :course_module

  has_one :course_year, through: :course_module

  # We use previous_lesson_id to store the connections between lessons
  # The id telling us which lesson is next lives on the next lesson, where it is called 'previous_lesson_id'
  # That's why the foreign key is named contrary to the field name
  has_one :next_lesson, class_name: "CourseLesson", foreign_key: :previous_lesson_id
  belongs_to :previous_lesson, class_name: "CourseLesson", inverse_of: :next_lesson, optional: true

  has_many :course_lesson_parts
  has_many :mentor_materials

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :completion_time_in_minutes, numericality: { greater_than: 0, allow_nil: true, message: "Enter a number greater than 0" }

  attr_accessor :progress, :new_position

  after_commit :update_to_new_position

  def course_lesson_parts_in_order
    preloaded_parts = course_lesson_parts.includes(:previous_lesson_part, :next_lesson_part)
    elements_in_order(elements: preloaded_parts, get_previous_element: :previous_lesson_part)
  end

  def duration_in_minutes_in_words
    number_of_hours = completion_time_in_minutes / 60
    number_of_minutes = completion_time_in_minutes % 60

    hour_string = "hour".pluralize(number_of_hours)
    minute_string = "minute".pluralize(number_of_minutes)

    if number_of_hours.positive? && number_of_minutes.positive?
      "#{number_of_hours} #{hour_string} #{number_of_minutes} #{minute_string}"
    elsif number_of_hours.positive?
      "#{number_of_hours} #{hour_string}"
    else
      "#{number_of_minutes} #{minute_string}"
    end
  end

  def mentor_summary_to_html
    Govspeak::Document.new(mentor_summary, options: { allow_extra_quotes: true }).to_html
  end

  def ect_summary_to_html
    Govspeak::Document.new(ect_summary, options: { allow_extra_quotes: true }).to_html
  end

  def module_and_lesson
    "#{course_module.title}: #{title}"
  end

private

  def update_to_new_position
    if new_position.present?
      insert_at(new_position.to_i)
    end
  end
end
