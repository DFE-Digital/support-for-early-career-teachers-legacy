# frozen_string_literal: true

class CoreInductionProgrammes::ModulesController < ApplicationController
  include Pundit
  include CipBreadcrumbHelper

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_course_module, only: %i[update edit show]
  before_action :make_course_module, only: %i[new create]
  before_action :fill_data_layer

  def show
    @course_lessons_with_progress = @course_module.lessons_with_progress current_user
  end

  def new; end

  def create
    next_module = find_next_module
    @course_module.assign_attributes(course_module_params)

    if @course_module.valid?
      @course_module.save!
      next_module&.update!(previous_module: @course_module)
      redirect_to module_path(@course_module)
    else
      render action: "new"
    end
  end

  def edit; end

  def update
    next_module = @course_module.next_module
    previous_module = @course_module.previous_module
    @course_module.assign_attributes(course_module_params)

    if params[:commit] == "Save changes"
      @course_module.save!
      next_module&.update!(previous_module: previous_module)

      flash[:success] = "Your changes have been saved"
      redirect_to module_path
    else
      render action: "edit"
    end
  end

private

  def make_course_module
    @core_induction_programme = load_core_induction_programme_from_params

    authorize CourseModule
    @course_years = @core_induction_programme.course_years
    @course_modules = CourseModule.where(course_year_id: @course_years.map(&:id))
    @course_module = CourseModule.new
  end

  def load_course_module
    @course_module = load_course_module_from_params
    @course_years = @course_module.course_year.core_induction_programme&.course_years || []
    @course_modules = @course_module.other_modules_in_year
    authorize @course_module
  end

  def course_module_params
    params
        .require(:course_module)
        .permit(:ect_summary, :mentor_summary, :title, :page_header, :term, :course_year_id, :previous_module_id)
  end

  def find_next_module
    previous_module_id = params[:course_module][:previous_module_id]
    previous_module = CourseModule.where(id: previous_module_id).first
    previous_module&.next_module
  end

  def fill_data_layer
    data_layer.add_module_info(@course_module)
  end
end
