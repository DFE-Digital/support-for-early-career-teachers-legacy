# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!, except: :show
  before_action :load_mentor_material, only: %i[show edit update]
  before_action :load_core_induction_materials, only: %i[edit update new create]
  before_action :fill_data_layer, only: %i[show edit update]

  def index
    @core_induction_programmes = CoreInductionProgramme.all
    authorize MentorMaterial
  end

  def show
    if @mentor_material.mentor_material_parts.present?
      redirect_to mentor_material_part_path(@mentor_material.mentor_material_parts_in_order[0])
    end
  end

  def edit; end

  def update
    @mentor_material.assign_attributes(mentor_material_params)

    @mentor_material.save!
    flash[:success] = "Your changes have been saved"
    redirect_to mentor_material_path
  end

  def new
    authorize MentorMaterial
    @mentor_material = MentorMaterial.new
    @course_lessons = CourseLesson.all
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
    @mentor_material = load_mentor_material_from_params
    @course_lessons = @mentor_material.core_induction_programme&.course_lessons
    authorize @mentor_material
  end

  def mentor_material_params
    params.require(:mentor_material).permit(:title, :core_induction_programme_id, :course_lesson_id)
  end

  def fill_data_layer
    data_layer.add_mentor_material_info(@mentor_material)
  end
end
