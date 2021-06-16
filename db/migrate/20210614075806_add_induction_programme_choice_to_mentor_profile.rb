# frozen_string_literal: true

class AddInductionProgrammeChoiceToMentorProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :mentor_profiles, :induction_programme_choice, :string, default: "not_yet_known"
  end
end
