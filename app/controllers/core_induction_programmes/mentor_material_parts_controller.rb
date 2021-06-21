# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialPartsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_mentor_material_part, only: :show

  def show; end

private

  def load_mentor_material_part
    @mentor_material_part = MentorMaterialPart.find(params[:id])
    authorize @mentor_material_part.mentor_material
  end
end
