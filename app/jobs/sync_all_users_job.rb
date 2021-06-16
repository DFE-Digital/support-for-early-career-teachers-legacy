# frozen_string_literal: true

class SyncAllUsersJob < CronJob
  self.cron_expression = "0 0 * * *"

  queue_as :sync_users

  def perform
    Rails.logger.info "Syncing all users with Register and Partner..."
    RegisterAndPartnerApi::SyncUsers.perform(all: true)
  end
end
