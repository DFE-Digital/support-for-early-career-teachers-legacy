# frozen_string_literal: true

class CoreInductionProgrammes::LessonPartsController < ApplicationController
  include Pundit
  include CipBreadcrumbHelper

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_course_lesson_part
  before_action :fill_data_layer, except: :update_progress

  def show; end

  def edit; end

  def update
    if params[:commit] == "Save changes"
      @course_lesson_part.save!
      flash[:success] = "Your changes have been saved"
      redirect_to lesson_part_path
    else
      render action: "edit"
    end
  end

  def show_split
    @split_lesson_part_form = SplitLessonPartForm.new(title: @course_lesson_part.title, content: @course_lesson_part.content)
  end

  def split
    @split_lesson_part_form = SplitLessonPartForm.new(lesson_split_params)
    if @split_lesson_part_form.valid? && params[:commit] == "Save changes"
      ActiveRecord::Base.transaction do
        @new_course_lesson_part = CourseLessonPart.create!(
          title: @split_lesson_part_form.new_title,
          content: @split_lesson_part_form.new_content,
          course_lesson: @course_lesson_part.course_lesson,
          next_lesson_part: @course_lesson_part.next_lesson_part,
          previous_lesson_part: @course_lesson_part,
        )
        @course_lesson_part.update!(title: @split_lesson_part_form.title, content: @split_lesson_part_form.content)
      end
      redirect_to lesson_part_path(@course_lesson_part)
    else
      render action: "show_split"
    end
  rescue ActiveRecord::RecordInvalid
    render action: "show_split"
  end

  def show_delete; end

  def destroy
    lesson = @course_lesson_part.course_lesson
    previous_lesson_part = @course_lesson_part.previous_lesson_part
    next_lesson_part = @course_lesson_part.next_lesson_part
    @course_lesson_part.destroy!
    next_lesson_part.update!(previous_lesson_part: previous_lesson_part)
    redirect_to lesson_path(lesson)
  end

  def update_progress
    redirect_to :show and return unless current_user&.early_career_teacher?

    if @lesson_progress.update(lesson_progress_params)
      redirect_to module_path(@course_lesson_part.course_lesson.course_module)
    else
      render :show
    end
  end

private

  def load_course_lesson_part
    @course_lesson_part = load_course_lesson_part_from_params

    authorize @course_lesson_part
    @course_lesson_part.assign_attributes(course_lesson_part_params)
    if current_user&.early_career_teacher?
      load_progress
    end
  end

  def load_progress
    @lesson_progress = CourseLessonProgress.find_or_create_by!(
      early_career_teacher_profile: current_user.early_career_teacher_profile,
      course_lesson: @course_lesson_part.course_lesson,
    )
    @lesson_progress.progress = nil
  end

  def course_lesson_part_params
    params.permit(:content, :title)
  end

  def lesson_split_params
    params.require(:split_lesson_part_form).permit(:title, :content, :new_title, :new_content)
  end

  def lesson_progress_params
    params.fetch(:course_lesson_progress, {}).permit(:progress)
  end

  def fill_data_layer
    data_layer.add_lesson_part_info(@course_lesson_part)
  end
end
