# frozen_string_literal: true

class AddInductionProgrammeChoiceToEarlyCareerTeacherProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :early_career_teacher_profiles, :induction_programme_choice, :string
  end
end
