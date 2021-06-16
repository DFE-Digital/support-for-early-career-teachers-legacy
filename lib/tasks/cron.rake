# frozen_string_literal: true

namespace :cron do
  desc "Updates DelayedJob cron-scheduled tasks"
  task schedule: :environment do
    SyncUsersJob.schedule
    SyncAllUsersJob.schedule
  end
end
