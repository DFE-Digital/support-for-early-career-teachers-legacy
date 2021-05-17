# frozen_string_literal: true

module RegisterAndPartnerApi
  class SyncUsers
    def self.perform
      # TODO: Add the last time we synced users, to avoid getting too many of them back
      # TODO: Add pagination
      begin
        sync_users(RegisterAndPartnerApi::User.all)
      rescue JsonApiClient::Errors::ClientError
        # This is how the API responds when we run out of pages :/
      end
    rescue StandardError
      Rails.logger.warn("Failed to sync users")
    end

    def self.sync_users(users)
      logger = Rails.logger
      users.each do |remote_user|
        attributes = user_attributes_from(remote_user)

        user = ::User.find_or_initialize_by(email: attributes[:email])
        user.full_name = attributes[:full_name]

        ect_profile = ::EarlyCareerTeacherProfile.find_or_initialize_by(user: user)
        ect_profile.core_induction_programme = CoreInductionProgramme.find_by(name: attributes[:cip])

        ect_profile.save!
        user.save!
      rescue StandardError
        logger.warn("Error saving user!")
      end
    end

    def self.user_attributes_from(user_from_api)
      {
        register_and_partner_id: user_from_api.attributes[:id],
        full_name: user_from_api.attributes[:attributes][:full_name],
        email: user_from_api.attributes[:attributes][:email],
        cip: "UCL",
      }
    end

    private_class_method :sync_users, :user_attributes_from
  end
end
