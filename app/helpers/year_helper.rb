# frozen_string_literal: true

module YearHelper
  def show_create_year?(cip)
    cip.course_years.count < 2
  end
end
