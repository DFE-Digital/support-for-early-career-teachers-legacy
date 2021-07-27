# frozen_string_literal: true

module RegisterAndPartnerApi
  class User < RegisterAndPartnerApi::Resource
    def self.path(_params = nil)
      "ecf-users"
    end

    def self.table_name
      "data"
    end
  end
end
