# frozen_string_literal: true

class LessonSummaryComponent < ViewComponent::Base
  def initialize(lesson:, user:)
    @user = user
    @lesson = lesson
    @mentor_materials = @lesson.mentor_materials
    @lesson_title = @lesson.title_for(@user)
    @lesson_has_self_study = @lesson.course_lesson_parts.any?
    @teacher_standards = @lesson.teacher_standards_for(@user)
  end
end
