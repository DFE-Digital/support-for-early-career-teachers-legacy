# frozen_string_literal: true

class AddCoreInductionProgrammeToMentors < ActiveRecord::Migration[6.1]
  def change
    add_reference :mentor_profiles, :core_induction_programme, null: true, foreign_key: true, type: :uuid, index: { name: :index_mentor_profiles_on_core_induction_programme_id }
    add_reference :mentor_profiles, :cohort, null: true, foreign_key: true, type: :uuid
    remove_reference :early_career_teacher_profiles, :mentor_profile
  end
end
