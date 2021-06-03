# frozen_string_literal: true

module RegisterAndPartnerApi
  class SyncUsers
    USER_TYPES = {
      ect: "early_career_teacher",
      mentor: "mentor",
    }.freeze

    CIP_TYPES = {
      ambition: "Ambition Institute",
      edt: "Education Development Trust",
      teach_first: "Teach First",
      ucl: "UCL",
      none: "none",
    }.freeze

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

        case attributes[:user_type]
        when USER_TYPES[:ect]
          find_or_create_user(attributes, ::EarlyCareerTeacherProfile)
        when USER_TYPES[:mentor]
          find_or_create_user(attributes, ::MentorProfile)
        end

      rescue StandardError
        logger.warn("Error saving user!")
      end
    end

    def self.user_attributes_from(user_from_api)
      {
        register_and_partner_id: user_from_api.attributes[:id],
        full_name: user_from_api.attributes[:attributes][:full_name],
        email: user_from_api.attributes[:attributes][:email],
        user_type: user_from_api.attributes[:attributes][:user_type],
        cip: user_from_api.attributes[:attributes][:core_induction_programme],
      }
    end

    def self.find_or_create_user(attributes, profile_class)
      user = ::User.find_or_initialize_by(register_and_partner_id: attributes[:register_and_partner_id])
      needs_inviting = !user.persisted?
      save_user(attributes, user, profile_class)

      if needs_inviting
        InviteParticipants.run([user.email])
      end
    end

    def self.save_user(attributes, user, profile_class)
      profile = profile_class.find_or_initialize_by(user: user)
      user.email = attributes[:email]
      user.full_name = attributes[:full_name]
      user.save!
      profile.core_induction_programme = get_core_induction_programme(attributes)
      profile.save!
    end

    def self.get_core_induction_programme(attributes)
      name = case attributes[:cip]
             when CIP_TYPES[:ambition]
               "Ambition Institute"
             when CIP_TYPES[:edt]
               "Education Development Trust"
             when CIP_TYPES[:teach_first]
               "Teach First"
             when CIP_TYPES[:ucl]
               "UCL"
             end
      CoreInductionProgramme.find_by(name: name)
    end

    private_class_method :sync_users, :user_attributes_from, :find_or_create_user, :save_user, :get_core_induction_programme
  end
end
