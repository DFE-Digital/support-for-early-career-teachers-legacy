# frozen_string_literal: true

class CoreInductionProgrammes::LessonsController < CoreInductionProgrammes::ModulesController
  include Pundit
  include CipBreadcrumbHelper

  skip_before_action :load_course_module_internal
  skip_before_action :make_course_module

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_course_lesson_internal, only: %i[show edit update]
  before_action :fill_data_layer, only: %i[show edit update]

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
    load_course_module
    id = (params[:lesson_id] || params[:id]).to_i - 1
    @course_lesson = @course_module.course_lessons[id]
  end

  def load_course_lesson_internal
    load_course_lesson
    @course_modules = CourseModule.where(course_year: @course_lesson.course_year)
    authorize @course_lesson
  end

  def course_lesson_params
    params.require(:course_lesson).permit(
      :title,
      :mentor_title,
      :ect_teacher_standards,
      :mentor_teacher_standards,
      :ect_summary,
      :mentor_summary,
      :completion_time_in_minutes,
      :course_module_id,
      :new_position,
    )
  end

  def fill_data_layer
    data_layer.add_lesson_info(@course_lesson)
  end
end
