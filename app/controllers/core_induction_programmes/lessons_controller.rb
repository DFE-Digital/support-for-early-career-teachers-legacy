# frozen_string_literal: true

class CoreInductionProgrammes::LessonsController < ApplicationController
  include Pundit
  include GovspeakHelper
  include CipBreadcrumbHelper

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_course_lesson, only: %i[show edit update]

  def show
    if current_user&.early_career_teacher?
      CourseLessonProgress.find_or_create_by!(
        early_career_teacher_profile: current_user.early_career_teacher_profile,
        course_lesson: @course_lesson,
      )
    end
    if @course_lesson.course_lesson_parts.first
      redirect_to lesson_part_path(@course_lesson.course_lesson_parts_in_order[0])
    end
  end

  def edit; end

  def update
    if @course_lesson.update(course_lesson_params)
      flash[:success] = "Your changes have been saved"
      redirect_to lesson_path
    else
      render action: "edit"
    end
  end

  def new
    @cip = CoreInductionProgramme.find(params[:cip_id])
    @course_lesson = CourseLesson.new
    @course_modules = @cip.course_modules
    authorize @course_lesson
  end

  def create
    @cip = CoreInductionProgramme.find(params[:cip_id])
    @course_lesson = CourseLesson.new(course_lesson_params)
    @course_modules = @cip.course_modules
    authorize @course_lesson

    if @course_lesson.save
      flash[:success] = "Your lesson has been created"
      redirect_to lesson_path(@course_lesson)
    else
      render :new
    end
  end

private

  def load_course_lesson
    @course_lesson = CourseLesson.find(params[:id])
    @course_modules = CourseModule.where(course_year: @course_lesson.course_year)
    authorize @course_lesson
  end

  def course_lesson_params
    params.require(:course_lesson).permit(:title, :mentor_title, :ect_summary, :mentor_summary, :completion_time_in_minutes, :course_module_id, :new_position)
  end
end
