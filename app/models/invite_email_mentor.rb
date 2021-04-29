# frozen_string_literal: true

class InviteEmailMentor < TrackedEmail
  def mail_to_send
    UserMailer.mentor_welcome_email(user)
  end
end
