# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialPartsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_mentor_material_part

  def show; end

  def edit; end

  def update
    @mentor_material_part.assign_attributes(mentor_material_part_params)

    if params[:commit] == "Save changes"
      @mentor_material_part.save!
      flash[:success] = "Your changes have been saved"
      redirect_to mentor_material_part_path
    else
      render action: "edit"
    end
  end

  def show_delete; end

  def destroy
    mentor_material = @mentor_material_part.mentor_material
    @mentor_material_part.destroy!
    redirect_to mentor_material_path(mentor_material)
  end

private

  def load_mentor_material_part
    @mentor_material_part = MentorMaterialPart.find(params[:mentor_material_part_id] || params[:id])
    authorize @mentor_material_part.mentor_material
  end

  def mentor_material_part_params
    params.permit(:content, :title)
  end
end
