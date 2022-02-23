# frozen_string_literal: true

class InviteParticipants
  def self.run(emails, force_send: false)
    logger.info "Emailing Participants"

    user = nil
    emails.each do |email|
      user = User.find_by(email: email)
      email = create_invite_email_for_user(user)
      email.send!(force_send: force_send)
    rescue StandardError
      logger.info "Error emailing user, id: #{user&.id} ... skipping"
    end
  end

  def self.create_invite_email_for_user(user)
    if user.external_user?
      set_token_and_expiry(user)
      return InviteEmailExternalUser.create!(user: user)
    end

    return unless user.is_on_core_induction_programme?

    if user.mentor?
      InviteEmailMentor.find_or_create_by!(user: user)
    elsif user.early_career_teacher?
      InviteEmailEct.find_or_create_by!(user: user)
    end
  end

  def self.set_token_and_expiry(user)
    external_user_profile = user.external_user_profile
    token_expiry = 60.minutes.from_now
    external_user_profile.update!(
      verification_token: SecureRandom.hex(10),
      verification_expires_at: token_expiry,
    )
  end

  def self.logger
    @logger ||= Rails.logger
  end

  private_class_method :create_invite_email_for_user, :logger
end
