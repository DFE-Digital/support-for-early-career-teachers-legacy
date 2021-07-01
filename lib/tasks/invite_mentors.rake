# frozen_string_literal: true

namespace :invites do
  desc "Invite mentor users"
  task send_mentor_invites: :environment do
    puts("Sending mentor invites...")

    unsent_emails = InviteEmailMentor.where(sent_at: nil)
    unsent_emails.each do
      email.send!(force_send: true)
    rescue Notifications::Client::RateLimitError
      sleep(1)
      email.send!(force_send: true)
    rescue StandardError
      puts("Error sending email, id: #{email&.id} ... skipping")
    end

    puts("Sending mentor invites finished")
  end
end
