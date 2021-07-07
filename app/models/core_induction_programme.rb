# frozen_string_literal: true

class CoreInductionProgramme < ApplicationRecord
  # TODO: Remove them after running the migration on all environments
  belongs_to :course_year_one, class_name: "CourseYear", optional: true
  belongs_to :course_year_two, class_name: "CourseYear", optional: true

  has_many :course_years, -> { order(position: :asc) }
  has_many :course_modules, through: :course_years
  has_many :course_lessons, through: :course_modules
  has_many :mentor_materials, through: :course_lessons

  has_many :early_career_teacher_profiles
  has_many :early_career_teachers, through: :early_career_teacher_profiles, source: :user

  validates :slug, presence: true

  def to_param
    slug
  end
end
