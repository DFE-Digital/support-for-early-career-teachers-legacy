# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(email: params.dig(:user, :email))
    @external_user_profile = @user.external_user_profile || ExternalUserProfile.new

    if email_taken?
      # TODO
      send_magic_link(existing_user)
      render :email_already_exists
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
      # TODO
    else
      set_user_as_verified
      sign_in_user
      render :email_confirmed
    end
  end

  def email_taken?
    existing_user.present? && existing_user.external_user_profile.blank?
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
end
