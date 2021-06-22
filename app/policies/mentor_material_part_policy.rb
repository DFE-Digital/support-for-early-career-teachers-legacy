# frozen_string_literal: true

class MentorMaterialPartPolicy < MentorMaterialPolicy
  def initialize(user, material_part)
    super(user, material_part.mentor_material)
    @material_part = material_part
  end

  alias_method :show_split?, :update?
  alias_method :split?, :update?

  def destroy?
    @user&.admin? && @material.mentor_material_parts.length > 1
  end

  alias_method :show_delete?, :destroy?
end
