# frozen_string_literal: true

namespace :invites do
  desc "Send ECT invites"
  task :send_invites, [:emails] => :environment do |_task, args|
    InviteParticipants.new.run(args.emails.split)
  end
end
