# frozen_string_literal: true

namespace :invites do
  desc "Send invites"
  task :send_invites, [:emails] => :environment do |_task, args|
    InviteParticipants.run(args.emails.split)
  end
end
