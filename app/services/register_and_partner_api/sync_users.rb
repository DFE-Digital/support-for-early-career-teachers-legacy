# frozen_string_literal: true

module RegisterAndPartnerApi
  class SyncUsers
    def self.perform
      # TODO: Add the last time we synced users, to avoid getting too many of them back
      begin
        (1..).each do |page|
          sync_users(
            RegisterAndPartnerApi::User
                .paginate(page: page, per_page: 500)
                .all,
          )
        end
      rescue JsonApiClient::Errors::ClientError
        # This is how the API responds when we run out of pages :/
      end

      # TODO: Make sure it works
      # RegisterAndPartnerApi::SyncCheck.set_last_sync(Time.zone.now)
    rescue JsonApiClient::Errors::ApiError
      # TODO: Once the API is set up and working on R&P, uncomment that line
      # raise RegisterAndPartnerApi::SyncError
    end

    def self.sync_users(users)
      # TODO: For each user, update that user, their profiles, their connections
      # Preferably directly from the data received in here - I don't want to have another API request per user
    end

    private_class_method :sync_users
  end
end
