# frozen_string_literal: true

class RemoveReferenceToYearFromCip < ActiveRecord::Migration[6.1]
  def change
    remove_reference :core_induction_programmes, :course_year_one
    remove_reference :core_induction_programmes, :course_year_two
  end
end
