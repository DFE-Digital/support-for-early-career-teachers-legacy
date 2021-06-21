# frozen_string_literal: true

class MentorMaterialPolicy < CoreInductionProgrammePolicy
  def show?
    return false unless has_access_to_cip?(@user, @record.get_core_induction_programme)

    @user&.mentor? || @user&.admin?
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
