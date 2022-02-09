# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
  end

  def create
    @external_user_profile = ExternalUserProfile.new
    @user = User.new(email: params.dig(:user, :email))

    if create_user
      render :email_sent
    elsif email_taken?
      send_magic_link(existing_user)
      render :email_already_exists
    else
      @external_user_profile.errors.merge!(@user)
      render :new
    end
  end

  def email_taken?
    existing_user.present?
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
end
