# frozen_string_literal: true

class CoreInductionProgrammes::LessonPartsController < ApplicationController
  include Pundit
  include GovspeakHelper
  include CipBreadcrumbHelper

  after_action :verify_authorized
  before_action :authenticate_user!, except: :show
  before_action :load_course_lesson_part, except: :update_progress

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
      redirect_to lesson_part_path(id: params[:lesson_part_id])
    else
      render action: "show_split"
    end
  rescue ActiveRecord::RecordInvalid
    render action: "show_split"
  end

  def show_delete; end

  def destroy
    @course_lesson_part = CourseLessonPart.find(params[:id])
    lesson = @course_lesson_part.course_lesson
    @course_lesson_part.destroy!
    redirect_to lesson_path(lesson)
  end

  def update_progress
    redirect_to :show and return unless current_user&.early_career_teacher?

    @course_lesson_part = CourseLessonPart.find(params[:lesson_part_id])
    authorize @course_lesson_part.course_lesson
    load_progress
    if @lesson_progress.update(lesson_progress_params)
      redirect_to module_path(@course_lesson_part.course_lesson.course_module)
    else
      render :show
    end
  end

private

  def load_course_lesson_part
    @course_lesson_part = CourseLessonPart.find(params[:id] || params[:lesson_part_id])
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
end
