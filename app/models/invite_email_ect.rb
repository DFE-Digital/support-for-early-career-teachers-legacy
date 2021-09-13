# frozen_string_literal: true

class InviteEmailEct < TrackedEmail
  def mail_to_send
    UserMailer.ect_welcome_email(user)
  end

  def send!(force_send: false)
    return unless user.is_on_core_induction_programme?

    can_send_automatically = email_sending_enabled? && user.registered_participant?
    if can_send_automatically || force_send
      super
    end
  end
end
