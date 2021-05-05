# frozen_string_literal: true

module RegisterAndPartnerApi
  class User < RegisterAndPartnerApi::Resource
    property :id, type: :string
    property :full_name, type: :string
    property :email, type: :string
  end
end
