# frozen_string_literal: true

class CourseLessonPolicy < CourseModulePolicy
  def show?
    has_access_to_year(@user, @record.course_module.course_year)
  end

  def update_progress?
    user&.early_career_teacher?
  end
end
