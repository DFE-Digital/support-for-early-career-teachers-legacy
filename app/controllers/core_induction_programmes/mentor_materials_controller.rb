# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialsController < ApplicationController
  def index
    @mentor_materials = MentorMaterial.all
  end

  def show
    @mentor_material = MentorMaterial.find(params[:id])
  end
end
