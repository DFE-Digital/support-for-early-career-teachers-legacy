# frozen_string_literal: true

class RestructureCipToYearRelation < ActiveRecord::Migration[6.1]
  def change
    add_reference :course_years, :core_induction_programme, null: true, foreign_key: true, type: :uuid
    add_column :course_years, :position, :integer, default: 0
    CourseYear.reset_column_information

    CourseYear.all.each do |course_year|
      if course_year.core_induction_programme_one
        course_year.update!(core_induction_programme: course_year.core_induction_programme_one, position: 1)
      else
        course_year.update!(core_induction_programme: course_year.core_induction_programme_two, position: 2)
      end
    end

    change_column_null :course_years, :core_induction_programme_id, false
  end
end
