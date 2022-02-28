# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: Rails.application.config.demo_password, password: Rails.application.config.demo_password, except: :check if Rails.env.staging?
  include ApplicationHelper
  include PathHelper
  include LoadResourcesHelper

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_sentry_user, except: :check, unless: :devise_controller?

  def check
    head :ok
  end

  def redirect_to_dashboard
    redirect_to after_sign_in_path_for(current_user) if current_user.present?
  end

  def after_sign_in_path_for(user)
    stored_location_for(user) || default_path(user)
  end

  def default_path(user)
    if user.external_user?
      external_users_home_path
    else
      dashboard_path
    end
  end

  def after_sign_out_path_for(_user)
    users_signed_out_path
  end

  def send_magic_link(user)
    token_expiry = 60.minutes.from_now
    result = user&.update(
      login_token: SecureRandom.hex(10),
      login_token_valid_until: token_expiry,
    )

    if result
      url = Rails.application.routes.url_helpers.users_confirm_sign_in_url(
        login_token: user.login_token,
        host: Rails.application.config.domain,
        **UtmService.email(:sign_in),
      )

      UserMailer.sign_in_email(user: user, url: url, token_expiry: token_expiry.localtime.to_s(:time)).deliver_now
    end
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
