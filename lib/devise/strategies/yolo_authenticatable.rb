# frozen_string_literal: true

require "devise/strategies/authenticatable"

module Devise
  module Strategies
    class YoloAuthenticatable < Authenticatable
      # Validation is handled by authenticate! below so that errors look nicer
      def valid?
        true
      end

      def authenticate!
        if params[:user].present?
          email = params[:user][:email]

          if email == ""
            user = User.new
            user.errors.add :email, "Enter an email address"
            success! user
            return
          end

          unless email.match(Devise.email_regexp)
            user = User.new
            user.errors.add :email, "Enter an email address in the correct format, like name@school.org"
            success! user
            return
          end

          user = User.find_by(email: email)

          unless user
            RegisterAndPartnerApi::SyncUsers.perform
            user = User.find_by(email: email)
          end

          if user.blank?
            user = User.new
            user.errors.add :email, "Enter the email address your school used when they registered your account"
          end

          success! user
        end
      end
    end
  end
end

Warden::Strategies.add(:yolo_authenticatable, Devise::Strategies::YoloAuthenticatable)
