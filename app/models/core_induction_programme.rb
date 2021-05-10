# frozen_string_literal: true

class CoreInductionProgramme < ApplicationRecord
  belongs_to :course_year_one, class_name: "CourseYear", optional: true
  belongs_to :course_year_two, class_name: "CourseYear", optional: true
  has_many :early_career_teacher_profiles
  has_many :early_career_teachers, through: :early_career_teacher_profiles, source: :user
  has_many :mentor_materials

  def course_years
    CourseYear.where(id: [course_year_one&.id, course_year_two&.id].compact)
  end

  def course_modules
    CourseModule.where(course_year: course_years)
  end

  def course_lessons
    CourseLesson.where(course_module: course_modules)
  end
end
