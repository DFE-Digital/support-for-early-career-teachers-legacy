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
      core_induction_programmes_id
      core_induction_programmes_name
      course_years_title
      course_modules_id
      course_modules_title
      course_lessons_id
      course_lessons_title
      course_lessons_parts_id
      course_lessons_parts_title
    ]
  end

  def course_lesson_parts
    @course_lesson_parts = CourseLessonPart.includes(course_lesson: { course_module: { course_year: :core_induction_programme } })
  end
end
