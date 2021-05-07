# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!, except: :show
  before_action :load_mentor_material, only: %i[show edit update]
  before_action :load_core_induction_materials, only: %i[edit update new create]

  def index
    @mentor_materials = MentorMaterial.all
    authorize MentorMaterial
  end

  def show; end

  def edit; end

  def update
    @mentor_material.assign_attributes(mentor_material_params)

    if params[:commit] == "Save"
      @mentor_material.save!
      flash[:success] = "Your changes have been saved"
      redirect_to mentor_material_path
    else
      render :edit
    end
  end

  def new
    authorize MentorMaterial
    @mentor_material = MentorMaterial.new
  end

  def create
    authorize MentorMaterial
    @mentor_material = MentorMaterial.new(mentor_material_params)
    if @mentor_material.save
      flash[:success] = "Mentor material created"
      redirect_to mentor_material_path(@mentor_material)
    else
      render :new
    end
  end

private

  def load_core_induction_materials
    @core_induction_programmes = CoreInductionProgramme.all
  end

  def load_mentor_material
    @mentor_material = MentorMaterial.find(params[:id])
    @course_lessons = @mentor_material.core_induction_programme&.course_lessons
    authorize @mentor_material
  end

  def mentor_material_params
    params.require(:mentor_material).permit(:title, :content, :core_induction_programme_id, :course_lesson_id)
  end
end
