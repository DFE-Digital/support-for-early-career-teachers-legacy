# frozen_string_literal: true

module RegisterAndPartnerApi
  class EarlyCareerTeacherProfile < RegisterAndPartnerApi::Resource
    belongs_to :user
  end
end
