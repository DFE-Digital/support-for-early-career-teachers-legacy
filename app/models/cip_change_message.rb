# frozen_string_literal: true

class CipChangeMessage < ApplicationRecord
  belongs_to :user
  belongs_to :original_cip, class_name: "CoreInductionProgramme"
  belongs_to :new_cip, class_name: "CoreInductionProgramme"
end
