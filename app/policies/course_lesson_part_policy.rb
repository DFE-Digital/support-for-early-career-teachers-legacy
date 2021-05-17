# frozen_string_literal: true

class CourseLessonPartPolicy < CourseLessonPolicy
  def show?
    has_access_to_year(@user, @record.course_lesson.course_module.course_year)
  end

  def show_split?
    edit?
  end

  def split?
    update?
  end

  def show_delete?
    destroy?
  end

  def destroy?
    update? && @record.course_lesson.course_lesson_parts.length > 1
  end
end
