# frozen_string_literal: true

module CourseYearHelper
  def get_user_lessons_and_progresses(ect_profile)
    course_lessons = CourseLesson.where(course_module: course_modules)

    user_progresses = CourseLessonProgress.where(early_career_teacher_profile: ect_profile, course_lesson: course_lessons).includes(:course_lesson)

    course_lessons.map do |lesson|
      lesson.progress = user_progresses.find { |progress| progress.course_lesson == lesson }&.progress || "not_started"
      lesson
    end
  end
end
