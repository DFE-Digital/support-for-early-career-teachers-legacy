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

    def self.determine_core_induction_programme(cip_name)
      case cip_name
      when "ambition"
        CIP_TYPES[:ambition]
      when "edt"
        CIP_TYPES[:edt]
      when "teach_first"
        CIP_TYPES[:teach_first]
      when "ucl"
        CIP_TYPES[:ucl]
      end
    end

    def self.find_or_create_user(attributes, profile_class)
      user = ::User.find_or_initialize_by(register_and_partner_id: attributes[:register_and_partner_id])
      profile = profile_class.find_or_initialize_by(user: user)

      save_user_email_and_full_name(attributes, user)
      save_profile_core_induction_programme(attributes, profile)
    end

    def self.save_user_email_and_full_name(attributes, user)
      user.email = attributes[:email]
      user.full_name = attributes[:full_name]
      user.save!
    end

    def self.save_profile_core_induction_programme(attributes, profile)
      profile.core_induction_programme = CoreInductionProgramme.find_by(
        name: determine_core_induction_programme(attributes[:cip]),
      )
      profile.save!
    end

    private_class_method :sync_users, :user_attributes_from, :save_profile_core_induction_programme,
                         :determine_core_induction_programme, :save_user_email_and_full_name, :find_or_create_user
  end
end
