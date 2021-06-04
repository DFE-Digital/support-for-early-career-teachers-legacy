# frozen_string_literal: true

module RegisterAndPartnerApi
  class SyncUsersTimer
    USERS_API_KEY = "register-and-partner-users-v1"

    def self.set_last_sync(date)
      metadata = ApiMetadata.find_or_create_by!(endpoint_name: USERS_API_KEY)
      metadata.update!(last_called_at: date)
    end

    def self.last_sync
      metadata = ApiMetadata.find_or_create_by!(endpoint_name: USERS_API_KEY)
      metadata.last_called_at
    end
  end
end
