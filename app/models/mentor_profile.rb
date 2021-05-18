# frozen_string_literal: true

class MentorProfile < ApplicationRecord
  belongs_to :user
  belongs_to :core_induction_programme, optional: true
  belongs_to :cohort, optional: true
end
