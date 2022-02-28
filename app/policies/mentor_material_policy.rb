# frozen_string_literal: true

class MentorMaterialPolicy < CoreInductionProgrammePolicy
  def initialize(user, material)
    @user = user
    @material = material
  end

  def show?
    return false unless has_access_to_cip?(@user, @material.core_induction_programme)

    @user&.mentor? || @user&.admin? || @user&.external_user?
  end

  def update?
    @user&.admin?
  end

  alias_method :edit?, :update?

  def destroy?
    @user&.admin?
  end

  alias_method :show_delete?, :destroy?
end
