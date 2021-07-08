# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: Rails.application.config.demo_password, password: Rails.application.config.demo_password if Rails.env.staging?
  include ApplicationHelper
  include PathHelper
  include LoadResourcesHelper

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
