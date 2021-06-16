# frozen_string_literal: true

class MentorProfile < ApplicationRecord
  enum induction_programme_choice: {
    core_induction_programme: "core_induction_programme",
    full_induction_programme: "full_induction_programme",
    design_our_own: "design_our_own",
    no_early_career_teachers: "no_early_career_teachers",
    not_yet_known: "not_yet_known",
  }

  belongs_to :user
  belongs_to :core_induction_programme, optional: true
  belongs_to :cohort, optional: true
end
