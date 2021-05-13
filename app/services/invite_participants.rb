# frozen_string_literal: true

class InviteParticipants
  def run(emails)
    logger.info "Emailing Participants"

    user = nil
    emails.each do |email|
      user = User.find_by(email: email)
      email = create_invite_email_for_user(user)
      email.send!
    rescue StandardError
      logger.info "Error emailing user, id: #{user&.id} ... skipping"
    end
  end

private

  def create_invite_email_for_user(user)
    if user.mentor?
      InviteEmailMentor.create!(user: user)
    elsif user.early_career_teacher?
      InviteEmailEct.create!(user: user)
    end
  end

  def logger
    @logger ||= Rails.logger
  end
end
