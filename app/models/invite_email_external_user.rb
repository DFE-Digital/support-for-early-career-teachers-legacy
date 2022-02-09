# frozen_string_literal: true

class InviteEmailExternalUser < TrackedEmail
  def mail_to_send
    UserMailer.external_user_welcome_email(user)
  end
end
