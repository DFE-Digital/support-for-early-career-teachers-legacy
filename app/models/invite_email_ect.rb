# frozen_string_literal: true

class InviteEmailEct < TrackedEmail
  INVITES_SENT_FROM = Date.new(2021, 8, 20).beginning_of_day

  def mail_to_send
    UserMailer.ect_welcome_email(user)
  end

  def send!(force_send: false)
    return unless user.is_on_core_induction_programme?

    can_send_automatically = Time.zone.now >= INVITES_SENT_FROM
    if can_send_automatically || force_send
      super
    end
  end
end
