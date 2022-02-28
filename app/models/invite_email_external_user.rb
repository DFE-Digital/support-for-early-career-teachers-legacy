# frozen_string_literal: true

class InviteEmailExternalUser < TrackedEmail
  def mail_to_send
    token = user.external_user_profile.verification_token
    UserMailer.external_user_welcome_email(user, token)
  end
end
