# frozen_string_literal: true

class CourseModule < ApplicationRecord
  include OrderHelper
  include CourseLessonProgressHelper
  attr_accessor :progress

  belongs_to :course_year
  has_many :course_lessons, -> { order(position: :asc) }, dependent: :delete_all
  has_many :mentor_materials

  # We use previous_module_id to store the connections between modules
  # The id telling us which module is next lives on the next module, where it is called 'previous_module_id'
  # That's why the foreign key is named contrary to the field name
  has_one :next_module, class_name: "CourseModule", foreign_key: :previous_module_id
  belongs_to :previous_module, class_name: "CourseModule", inverse_of: :next_module, optional: true

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :ect_summary, presence: { message: "Enter ECT summary" }, length: { maximum: 100_000 }
  validate :check_previous_module_id

  def self.terms
    {
      autumn: "autumn",
      spring: "spring",
      summer: "summer",
    }
  end

  def self.term_options
    terms.values.map { |term| OpenStruct.new(id: term, name: term.capitalize) }
  end

  enum term: terms

  def mentor_summary_to_html
    Govspeak::Document.new(mentor_summary, options: { allow_extra_quotes: true }).to_html
  end

  def ect_summary_to_html
    Govspeak::Document.new(ect_summary, options: { allow_extra_quotes: true }).to_html
  end

  def lessons_with_progress(user)
    ect_profile = user&.early_career_teacher_profile
    return course_lessons unless ect_profile

    get_user_lessons_and_progresses(ect_profile, course_lessons)
  end

  def term_and_title
    "#{term.capitalize} #{title.downcase}"
  end

  def check_previous_module_id
    errors.add(:previous_module_id, "Select a different module") if previous_module == self
  end

  def other_modules_in_year
    course_year.course_modules.where.not(id: id)
  end
end
