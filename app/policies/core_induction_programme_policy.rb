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
    admin_only || external_user
  end

  def show?
    has_access_to_cip?(@user, @record)
  end

  def create?
    admin_only
  end

  def update?
    admin_only
  end

private

  def has_access_to_cip?(user, cip)
    return true if admin_only || external_user

    user && (user.core_induction_programme == cip)
  end
end
