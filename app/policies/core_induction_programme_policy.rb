# frozen_string_literal: true

class CoreInductionProgrammePolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    admin_only
  end

  def index?
    admin_only
  end

  def show?
    has_access_to_cip(@user, @record)
  end

  def create?
    admin_only
  end

  def update?
    admin_only
  end
end

private

def has_access_to_cip(user, cip)
  has_access_to_cip_as_ect?(user, cip) || has_access_to_cip_as_mentor?(user, cip) || admin_only
end

def has_access_to_cip_as_ect?(user, cip)
  return false unless user && cip

  user.core_induction_programme == cip
end

def has_access_to_cip_as_mentor?(user, cip)
  return false unless user && cip

  user.mentor_profile&.early_career_teachers&.one? do |ect|
    has_access_to_cip_as_ect? ect, cip
  end
end
