# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseLessonDataReportJob do
  describe "#perform" do
    it "persists report record" do
      create(:course_lesson_part)

      tempfile = Tempfile.new("course_lesson_data.csv")

      described_class.perform_now(tempfile.path)

      raw_data = File.open(tempfile.path).read

      data = CSV.parse(raw_data, headers: :first_row).map(&:to_h).map(&:symbolize_keys)
      expect(data.first).to match({
        core_induction_programmes_id: a_string_matching(UUID_REGEX),
        core_induction_programmes_name: "Test Core induction programme",
        course_years_title: "Test Course year",
        course_modules_id: a_string_matching(UUID_REGEX),
        course_modules_title: "Test Course module",
        course_lessons_id: a_string_matching(UUID_REGEX),
        course_lessons_title: a_string_matching(/Test Course lesson \d+/),
        course_lessons_parts_id: a_string_matching(UUID_REGEX),
        course_lessons_parts_title: "Test Course lesson part",
      })
    end
  end
end
