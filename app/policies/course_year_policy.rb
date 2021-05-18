# frozen_string_literal: true

class CourseYearPolicy < CoreInductionProgrammePolicy
  def index?
    false
  end

  def show?
    has_access_to_year?(@user, @record)
  end

private

  def has_access_to_year?(user, year)
    has_access_to_cip?(user, year.core_induction_programme_one) || has_access_to_cip?(user, year.core_induction_programme_two)
  end
end
