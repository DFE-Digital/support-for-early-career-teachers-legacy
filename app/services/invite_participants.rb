# frozen_string_literal: true

class InviteParticipants
  def self.run(emails)
    logger.info "Emailing Participants"

    user = nil
    emails.each do |email|
      user = User.find_by(email: email)
      email = create_invite_email_for_user(user)

      # if user is ect and before certain time, don't send
      # otherwise send
      email.send!
    rescue StandardError
      logger.info "Error emailing user, id: #{user&.id} ... skipping"
    end
  end

  def self.create_invite_email_for_user(user)
    if user.mentor?
      InviteEmailMentor.create!(user: user)
    elsif user.early_career_teacher?
      InviteEmailEct.create!(user: user)
    end
  end

  def self.logger
    @logger ||= Rails.logger
  end

  private_class_method :create_invite_email_for_user, :logger
end
