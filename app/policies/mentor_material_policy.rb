# frozen_string_literal: true

class MentorMaterialPolicy < CoreInductionProgrammePolicy
  def show?
    return false unless has_access_to_cip?(@user, @record.get_core_induction_programme)

    @user&.mentor? || @user&.admin?
  end
end
