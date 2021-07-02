# frozen_string_literal: true

class TrackedEmail < ApplicationRecord
  belongs_to :user

  def sent?
    sent_at.present?
  end

  def delivered?
    delivered_at.present?
  end

  def mail_to_send
    raise NotImplementedError
  end

  def send!(*)
    return if sent?

    self.notify_id = mail_to_send.deliver_now.delivery_method.response.id
    self.sent_to = user.email
    self.sent_at = Time.zone.now
    save!
  end
end
