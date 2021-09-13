# frozen_string_literal: true

require Rails.root.join("lib/devise/strategies/pretend_authenticatable")

module Devise
  module Models
    module PretendAuthenticatable
      extend ActiveSupport::Concern
    end
  end
end
