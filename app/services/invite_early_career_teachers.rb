# frozen_string_literal: true

class InviteEarlyCareerTeachers
  def run(ect_emails)
    logger.info "Emailing ECTs"

    ect_emails.each do |email|
      user = User.find_by(email: email)
      email = InviteEmailEct.create!(user: user)
      email.send!
    rescue StandardError
      logger.info "Error emailing ECT, id: #{user.id} ... skipping"
    end
  end

private

  def logger
    @logger ||= Rails.logger
  end
end
