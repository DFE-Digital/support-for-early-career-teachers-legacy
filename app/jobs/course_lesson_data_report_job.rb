# frozen_string_literal: true

class CourseLessonDataReportJob < ApplicationJob
  queue_as :default

  def perform
    report = Report.find_or_initialize_by(identifier: "course_lesson_data")
    report.update!(data: CourseLessonDataReport.new.call)
  end
end
