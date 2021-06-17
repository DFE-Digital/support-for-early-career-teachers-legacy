# frozen_string_literal: true

class InviteEmailEct < TrackedEmail
  INVITES_SENT_FROM = Date.new(2021, 8, 20).beginning_of_day

  def mail_to_send
    UserMailer.ect_welcome_email(user)
  end

  def send!
    if user.is_on_core_induction_programme? && Time.zone.now >= INVITES_SENT_FROM
      super
    end
  end
end
