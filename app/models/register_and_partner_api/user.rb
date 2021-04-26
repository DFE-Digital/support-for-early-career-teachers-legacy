# frozen_string_literal: true

module RegisterAndPartnerApi
  class User < RegisterAndPartnerApi::Resource
    def self.table_name
      "v1/users"
    end
  end
end
