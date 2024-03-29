# frozen_string_literal: true

class ReminderEmailMentor < TrackedEmail
  def mail_to_send
    UserMailer.mentor_sign_in_reminder_email(user)
  end

  def send!(force_send: false)
    return unless user.is_on_core_induction_programme?

    can_send_automatically = email_sending_enabled? && user.registered_participant?
    if can_send_automatically || force_send
      super
    end
  end
end
