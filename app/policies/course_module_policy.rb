# frozen_string_literal: true

class CourseModulePolicy < CourseYearPolicy
  def show?
    has_access_to_year(@user, @record.course_year)
  end
end
