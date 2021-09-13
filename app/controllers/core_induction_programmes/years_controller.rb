# frozen_string_literal: true

class CoreInductionProgrammes::YearsController < ApplicationController
  include Pundit
  include CipBreadcrumbHelper

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_course_year, except: %i[new create]
  before_action :fill_data_layer, except: %i[new create]

  def show
    @cip = @course_year.core_induction_programme
  end

  def new
    load_core_induction_programme_from_params
    authorize CourseYear
    @course_year = CourseYear.new
  end

  def create
    load_core_induction_programme_from_params
    authorize CourseYear
    @course_year = CourseYear.new(course_year_params)

    @course_year.core_induction_programme = @core_induction_programme
    if @course_year.valid?
      @course_year.save!
      redirect_to cip_path(@core_induction_programme)
    else
      render action: "new"
    end
  end

  def edit; end

  def update
    if params[:commit] == "Save changes"
      @course_year.save!
      flash[:success] = "Your changes have been saved"
      redirect_to year_path(@course_year)
    else
      render action: "edit"
    end
  end

private

  def load_course_year
    @course_year = load_course_year_from_params

    authorize @course_year
    @course_year.assign_attributes(course_year_params)
    @course_modules_with_progress = @course_year.modules_with_progress current_user
  end

  def course_year_params
    params.fetch(:course_year, {}).permit(:title, :mentor_title, :content, :core_induction_programme_id)
  end

  def fill_data_layer
    data_layer.add_year_info(@course_year)
  end
end
