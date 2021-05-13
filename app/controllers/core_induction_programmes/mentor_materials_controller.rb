# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!, except: :show
  before_action :load_mentor_material, except: :index

  def index
    @core_induction_programmes = CoreInductionProgramme.all
    authorize MentorMaterial
  end

  def show; end

  def edit; end

  def update
    @mentor_material.assign_attributes(mentor_material_params)

    if params[:commit] == "Save changes"
      @mentor_material.save!
      flash[:success] = "Your changes have been saved"
      redirect_to mentor_material_path
    else
      render action: "edit"
    end
  end

private

  def load_mentor_material
    @mentor_material = MentorMaterial.find(params[:id])
    @core_induction_programmes = CoreInductionProgramme.all
    @course_lessons = @mentor_material.core_induction_programme&.course_lessons
    authorize @mentor_material
  end

  def mentor_material_params
    params.require(:mentor_material).permit(:title, :content, :core_induction_programme_id, :course_lesson_id)
  end
end
