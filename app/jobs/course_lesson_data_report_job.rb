# frozen_string_literal: true

class CourseLessonDataReportJob < ApplicationJob
  queue_as :default

  OUTPUT_FILE_PATH = "/tmp/course_lesson_data.csv"

  def perform(output_file_path = OUTPUT_FILE_PATH)
    File.open(output_file_path, "w") { |f| f.write(CourseLessonDataReport.new.call) }
  end
end
