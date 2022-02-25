# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(email: params.dig(:user, :email))
    @external_user_profile = @user.external_user_profile || ExternalUserProfile.new

    if email_taken?
      if account_can_sign_in?
        send_magic_link(existing_user)
        render :email_already_exists
      else
        self.resource = @user
        render :"users/sessions/new"
      end
    elsif create_user
      render :email_sent
    else
      @external_user_profile.errors.merge!(@user)
      render :new
    end
  end

  def confirm_email
    @external_user_profile = ExternalUserProfile.find_by(verification_token: params[:token])

    if @external_user_profile.verification_token_expired?
      @user = @external_user_profile.user
      render :link_expired
    else
      set_user_as_verified
      sign_in_user
      render :email_confirmed
    end
  end

  def email_taken?
    existing_user.present? && !(existing_user.external_user_profile.present? && !existing_user.external_user_profile.verified?)
  end

  def existing_user
    return @existing_user if defined?(@existing_user)

    @existing_user = User.find_by_email(params.dig(:user, :email))
  end

  def create_user
    ActiveRecord::Base.transaction do
      @user.save
      @external_user_profile.user = @user
      @external_user_profile.save!
    end
    InviteParticipants.run([@user.email])
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid
    nil
  end

  def set_user_as_verified
    @external_user_profile.update!(verified: true)
  end

  def sign_in_user
    user = @external_user_profile.user
    user.update!(login_token: nil, login_token_valid_until: 1.year.ago)
    sign_in(user, scope: :user)
    stream_login_to_bigquery(@user)
  end

  def stream_login_to_bigquery(user)
    StreamBigqueryUserLoginJob.perform_later(user)
  end

  def account_can_sign_in?
    # external user must be verified to get to this point
    return true if existing_user.external_user_profile.present? || user_already_accessed_the_service?

    validity = true

    unless @user.is_cip_participant?
      @user.errors.add :induction_programme_choice, "Please go to your provider's system to access your training materials"
      validity = false
    end

    unless @user.core_induction_programme
      @user.errors.add :induction_programme_choice, "Your school has not selected a core induction programme for you, contact your school induction coordinator"
      validity = false
    end

    unless @user.registered_participant?
      @user.errors.add :email, "Please complete your registration"
      validity = false
    end

    validity
  end

  def user_already_accessed_the_service?
    InviteEmailMentor.where.not(sent_at: nil).find_by(user: @user.id).present? ||
      InviteEmailEct.where.not(sent_at: nil).find_by(user: @user.id).present?
  end
end
