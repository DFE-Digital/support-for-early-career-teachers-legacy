# frozen_string_literal: true

module RegisterAndPartnerApi
  class Resource < JsonApiClient::Resource
    self.site = ENV.fetch("REGISTER_AND_PARTNER_URL") + "/api/v1"
    self.connection_options = { headers: { user_agent: "Engage and Learn" } }
  end
end

RegisterAndPartnerApi::Resource.connection do |connection|
  connection.use Faraday::Response::Logger, Rails.logger, formatter: ApiRequestLoggingFormatter
end
