# frozen_string_literal: true

class SyncUsersJob < CronJob
  self.cron_expression = "*/5 * * * *"

  queue_as :sync_users

  def perform
    Rails.logger.info "Syncing users with Register and Partner..."
    RegisterAndPartnerApi::SyncUsers.perform
  end
end
