# frozen_string_literal: true

class ExternalUserProfile < ApplicationRecord
  belongs_to :user

  def verified?
    verified
  end

  def verification_token_expired?
    verification_expires_at < Time.zone.now
  end
end
