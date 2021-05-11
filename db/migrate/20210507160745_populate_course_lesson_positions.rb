# frozen_string_literal: true

class PopulateCourseLessonPositions < ActiveRecord::Migration[6.1]
  def up
    CourseModule.includes(:course_lessons).each do |course_module|
      lessons = []

      until lessons.size == course_module.course_lessons.size
        course_module.course_lessons.each do |lesson|
          next if lessons.include?(lesson)

          if lesson.previous_lesson_id.blank?
            lessons.prepend(lesson)
          elsif (index = lessons.find_index { |l| l.id == lesson.previous_lesson_id })
            lessons.insert(index + 1, lesson)
          elsif !course_module.course_lessons.include?(CourseLesson.find(lesson.previous_lesson_id))
            lessons.prepend(lesson)
          end
        end
      end

      lessons.each.with_index(1) do |lesson, index|
        lesson.update_column :position, index
      end
    end
  end

  def down
    CourseLesson.update_all(position: nil)
  end
end
