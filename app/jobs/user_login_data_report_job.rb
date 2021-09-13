# frozen_string_literal: true

class UserLoginDataReportJob < ApplicationJob
  queue_as :default

  def perform
    report = Report.find_or_initialize_by(identifier: "user_login_data")
    report.update!(data: UserLoginDataReport.new.call)
  end
end
