# frozen_string_literal: true

class InviteEmailMentor < TrackedEmail
  INVITES_SENT_FROM = Date.new(2021, 8, 31).beginning_of_day

  def mail_to_send
    UserMailer.mentor_welcome_email(user)
  end

  def send!(force_send: false)
    can_send_automatically = user.is_on_core_induction_programme? && Time.zone.now >= INVITES_SENT_FROM
    if can_send_automatically || force_send
      super
    end
  end
end
