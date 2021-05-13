# frozen_string_literal: true

module RegisterAndPartnerApi
  class SyncUsers
    def self.perform
      # TODO: Add the last time we synced users, to avoid getting too many of them back
      begin
        sync_users(RegisterAndPartnerApi::User.all)
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
      users.each do |remote_user|
        attributes = remote_user.attributes
        user = ::User.find_or_initialize_by(id: attributes[:id]) do |u|
          u.full_name = attributes[:full_name]
          u.email = attributes[:email]
        end
        user.save!
      end
    end

    private_class_method :sync_users
  end
end
