# frozen_string_literal: true

namespace :invites do
  desc "Send ECT invites"
  task :send_ect_invites, [:ect_emails] => :environment do |_task, args|
    InviteEarlyCareerTeachers.new.run(args.ect_emails.split)
  end
end
