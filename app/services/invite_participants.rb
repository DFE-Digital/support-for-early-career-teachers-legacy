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
    return unless user.is_on_core_induction_programme?

    if user.mentor?
      InviteEmailMentor.find_or_create_by!(user: user, sent_at: nil)
    elsif user.early_career_teacher?
      InviteEmailEct.find_or_create_by!(user: user, sent_at: nil)
    end
  end

  def self.logger
    @logger ||= Rails.logger
  end

  private_class_method :create_invite_email_for_user, :logger
end
