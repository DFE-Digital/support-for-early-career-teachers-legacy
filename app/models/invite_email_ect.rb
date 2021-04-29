# frozen_string_literal: true

class InviteEmailEct < TrackedEmail
  def mail_to_send
    UserMailer.ect_welcome_email(user)
  end
end
