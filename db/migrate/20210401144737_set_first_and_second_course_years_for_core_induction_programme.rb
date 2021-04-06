# frozen_string_literal: true

class SetFirstAndSecondCourseYearsForCoreInductionProgramme < ActiveRecord::Migration[6.1]
  def up
    CourseYear.all.each do |course_year|
      cip = CoreInductionProgramme.find(course_year[:core_induction_programme_id])
      if course_year.is_year_one?
        cip.update!(course_year_one_id: course_year[:id])
      else cip.update!(course_year_two_id: course_year[:id])
      end
    end
  end

  def down
    CoreInductionProgramme.all.each do |cip|
      course_year = CourseYear.find(cip[:course_year_one_id])
      if cip[:course_year_one_id].nil?
        course_year.update!(is_year_one: false)
      else
        course_year.update!(is_year_one: true)
      end
    end
  end
end
