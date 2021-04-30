# frozen_string_literal: true

class CoreInductionProgrammePolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    admin_only
  end

  def show?
    has_access_to_cip_as_ect?(@user) || has_access_to_cip_as_mentor?(@user) || admin_only
  end
end

private

def has_access_to_cip_as_ect?(user)
  user&.core_induction_programme == @record
end

def has_access_to_cip_as_mentor?(user)
  user&.mentor_profile&.early_career_teachers&.one? do |ect|
    has_access_to_cip_as_ect? ect
  end
end
