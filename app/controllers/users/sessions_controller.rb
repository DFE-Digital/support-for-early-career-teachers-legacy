# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :redirect_to_dashboard, only: %i[sign_in_with_token redirect_from_magic_link]
  before_action :ensure_login_token_valid, only: %i[sign_in_with_token redirect_from_magic_link]
  TEST_USERS = %w[admin@example.com].freeze

  def create
    self.resource = validate_email

    if resource.errors.any?
      render :new and return
    end

    if user_requires_magic_link(resource)
      send_magic_link(resource)
      render :login_email_sent
    else
      sign_in(resource_name, resource)
      stream_login_to_bigquery(resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  def sign_in_with_token
    @user.update!(login_token: nil, login_token_valid_until: 1.year.ago)
    sign_in(@user, scope: :user)
    stream_login_to_bigquery(@user)
    redirect_to after_sign_in_path_for(@user)
  end

  def redirect_from_magic_link
    @login_token = params[:login_token] if params[:login_token].present?
  end

  def signed_out; end

  def link_invalid; end

private

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

  def user_requires_magic_link(user)
    return false unless user&.admin?

    environment_allows_test_users = Rails.env.development? || Rails.env.deployed_development? || Rails.env.staging?
    user_is_test_user = TEST_USERS.include?(user.email)
    return false if environment_allows_test_users && user_is_test_user

    true
  end

  def validate_email
    if params[:user].nil?
      user = User.new
      user.errors.add :email, "Enter an email address"
      return user
    end

    email = params[:user][:email].downcase

    if email == ""
      user = User.new
      user.errors.add :email, "Enter an email address"
      return user
    end

    unless email.match(Devise.email_regexp)
      user = User.new
      user.errors.add :email, "Enter an email address in the correct format, like name@school.org"
      return user
    end

    user = User.find_by(email: email)

    if user.blank?
      user = User.new
      user.errors.add :email, "Enter the email address your school used when they registered your account"
    end

    return user unless user.participant?

    unless user.is_cip_participant?
      user.errors.add :induction_programme_choice, "Please go to your provider's system to access your training materials"
      return user
    end

    unless user.core_induction_programme
      user.errors.add :induction_programme_choice, "Your school has not selected a core induction programme for you, contact your school induction coordinator"
    end

    return user if user_already_accessed_the_service?(user)

    unless user.registered_participant?
      user.errors.add :email, "Please complete your registration"
    end

    user
  end

  def user_already_accessed_the_service?(user)
    InviteEmailMentor.where.not(sent_at: nil).find_by(user: user.id).present? ||
      InviteEmailEct.where.not(sent_at: nil).find_by(user: user.id).present?
  end

  def stream_login_to_bigquery(user)
    StreamBigqueryUserLoginJob.perform_later(user)
  end
end
