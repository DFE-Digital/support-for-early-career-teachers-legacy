# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :redirect_to_dashboard, only: %i[sign_in_with_token redirect_from_magic_link]
  before_action :ensure_login_token_valid, only: %i[sign_in_with_token redirect_from_magic_link]

  def new
    super do
      if flash.present?
        flash.clear
        resource.valid?
        resource.errors.delete(:full_name)
      end
    end
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.errors.any?
      render :new
    else
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  rescue Devise::Strategies::PasswordlessAuthenticatable::Error
    render :login_email_sent
  end

  def sign_in_with_token
    @user.update!(login_token: nil, login_token_valid_until: 1.year.ago)
    sign_in(@user, scope: :user)
    redirect_to after_sign_in_path_for(@user)
  end

  def redirect_from_magic_link
    @login_token = params[:login_token] if params[:login_token].present?
  end

  def signed_out; end

  def link_invalid; end

private

  def redirect_to_dashboard
    redirect_to after_sign_in_path_for(current_user) if current_user.present?
  end

  def ensure_login_token_valid
    @user = User.find_by(login_token: params[:login_token])

    if @user.blank? || login_token_expired?
      redirect_to users_link_invalid_path
    end
  end

  def login_token_expired?
    return true if @user.login_token_valid_until.nil?

    Time.zone.now > @user.login_token_valid_until
  end
end
