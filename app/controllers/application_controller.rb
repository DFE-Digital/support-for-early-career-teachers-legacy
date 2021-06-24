# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_sentry_user, except: :check, unless: :devise_controller?

  def check
    head :ok
  end

  def after_sign_in_path_for(user)
    stored_location_for(user) || dashboard_path
  end

  def after_sign_out_path_for(_user)
    users_signed_out_path
  end

  def url_options
    { provider_id: params[:provider_id] }.merge(super)
  end

  def year_path(course_year = @course_year, *args)
    provider_year_path(course_year, *args)
  end

  def module_path(course_module = @course_module, *args)
    provider_year_module_path(course_module.course_year, course_module, *args)
  end

  def edit_module_path(course_module = @course_module, *args)
    edit_provider_year_module_path(course_module.course_year, course_module, *args)
  end

  def lesson_path(course_lesson = @course_lesson, *args)
    provider_year_module_lesson_path(course_lesson.course_module.course_year, course_lesson.course_module, course_lesson, *args)
  end

  def edit_lesson_path(course_lesson = @course_lesson, *args)
    edit_provider_year_module_lesson_path(course_lesson.course_module.course_year, course_lesson.course_module, course_lesson, *args)
  end

  def lesson_part_path(lesson_part = @course_lesson_part, *args)
    provider_year_module_lesson_lesson_part_path(lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def edit_lesson_part_path(lesson_part = @course_lesson_part, *args)
    edit_provider_year_module_lesson_lesson_part_path(lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def lesson_part_split_path(lesson_part = @course_lesson_part, *args)
    provider_year_module_lesson_lesson_part_split_path(lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  def lesson_part_show_delete_path(lesson_part = @course_lesson_part, *args)
    provider_year_module_lesson_lesson_part_show_delete_path(lesson_part.course_lesson.course_module.course_year, lesson_part.course_lesson.course_module, lesson_part.course_lesson, lesson_part, *args)
  end

  helper_method :year_path, :module_path, :edit_module_path, :lesson_path, :edit_lesson_path, :lesson_part_path, :edit_lesson_part_path, :lesson_part_split_path, :lesson_part_show_delete_path

protected

  def release_version
    ENV["RELEASE_VERSION"] || "-"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email full_name])
  end

  def set_sentry_user
    return if current_user.blank?

    Sentry.set_user(id: current_user.id)
  end
end
