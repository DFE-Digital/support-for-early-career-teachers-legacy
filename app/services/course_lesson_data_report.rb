# frozen_string_literal: true

require "csv"

class CourseLessonDataReport
  def call
    CSV.generate do |csv|
      csv << headers

      course_lesson_parts.each do |clp|
        course_lesson = clp.course_lesson
        course_module = course_lesson.course_module
        course_year = course_module.course_year
        cip = course_year.core_induction_programme
        csv << [
          cip.id,
          cip.name,
          course_year.title,
          course_module.id,
          course_module.title,
          course_lesson.id,
          course_lesson.title,
          clp.id,
          clp.title,
        ]
      end
    end
  end

private

  def headers
    %w[
      core_induction_programmes.id
      core_induction_programmes.name
      course_years.title
      course_modules.id
      course_modules.title
      course_lessons.id
      course_lessons.title
      course_lessons_parts.id
      course_lessons_parts.title
    ]
  end

  def course_lesson_parts
    @course_lesson_parts = CourseLessonPart.includes(course_lesson: { course_module: { course_year: :core_induction_programme } })
  end
end
