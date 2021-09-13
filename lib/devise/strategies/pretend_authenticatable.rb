# frozen_string_literal: true

require "devise/strategies/authenticatable"

module Devise
  module Strategies
    class PretendAuthenticatable < Authenticatable
      # This strategy exists solely to make other devise mechanisms work for us.
      # Things like `authenticate_user!` will break without user model having some sort of Authenticatable strategy
      def authenticate!; end
    end
  end
end

Warden::Strategies.add(:pretend_authenticatable, Devise::Strategies::PretendAuthenticatable)
