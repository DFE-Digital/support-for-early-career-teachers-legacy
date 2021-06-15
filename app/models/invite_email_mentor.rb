# frozen_string_literal: true

class InviteEmailMentor < TrackedEmail
  INVITES_SENT_FROM = Date.new(2021, 6, 30).beginning_of_day

  def mail_to_send
    UserMailer.mentor_welcome_email(user)
  end

  def send!
    if user.is_on_core_induction_programme? && Time.zone.now >= INVITES_SENT_FROM
      super
    end
  end
end
