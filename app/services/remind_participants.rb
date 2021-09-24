# frozen_string_literal: true

class RemindParticipants
  def self.run(emails, force_send: false)
    logger.info "Emailing Participants"

    user = nil
    emails.each do |email|
      user = User.find_by(email: email)
      email = create_reminder_email_for_user(user)
      email.send!(force_send: force_send)
    rescue StandardError
      logger.info "Error emailing user, id: #{user&.id} ... skipping"
    end
  end

  def self.create_reminder_email_for_user(user)
    return unless user.is_on_core_induction_programme?

    if user.mentor?
      ReminderEmailMentor.create!(user: user)
    end
  end

  def self.logger
    @logger ||= Rails.logger
  end

  private_class_method :create_reminder_email_for_user, :logger
end
