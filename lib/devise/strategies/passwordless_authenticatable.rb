# frozen_string_literal: true

require "devise/strategies/authenticatable"
require_relative "../../../app/mailers/user_mailer"

module Devise
  module Strategies
    class PasswordlessAuthenticatable < Authenticatable
      TEST_USERS = %w[admin@example.com].freeze

      class Error < StandardError; end

      class EmailNotFoundError < Error; end

      class LoginIncompleteError < Error; end

      def valid?
        true
      end

      def authenticate!
        if params[:user].present?
          user = User.find_by(email: params[:user][:email].downcase)

          return success! user unless user_requires_magic_link(user)

          token_expiry = 60.minutes.from_now
          result = user&.update(
            login_token: SecureRandom.hex(10),
            login_token_valid_until: token_expiry,
          )

          if result
            url = Rails.application.routes.url_helpers.users_confirm_sign_in_url(
              login_token: user.login_token,
              host: Rails.application.config.domain,
              **UtmService.email(:sign_in),
            )

            UserMailer.sign_in_email(user: user, url: url, token_expiry: token_expiry.localtime.to_s(:time)).deliver_now
            raise LoginIncompleteError
          else
            raise EmailNotFoundError
          end
        end
      end

    private

      def user_requires_magic_link(user)
        return false unless user&.admin?

        environment_allows_test_users = Rails.env.development? || Rails.env.deployed_development? || Rails.env.staging?
        user_is_test_user = TEST_USERS.include?(user.email)
        return false if environment_allows_test_users && user_is_test_user

        true
      end
    end
  end
end

Warden::Strategies.add(:passwordless_authenticatable, Devise::Strategies::PasswordlessAuthenticatable)
