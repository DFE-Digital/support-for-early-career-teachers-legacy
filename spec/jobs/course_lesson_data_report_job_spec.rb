# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseLessonDataReportJob do
  describe "#perform" do
    it "persists report record" do
      create(:course_lesson_part)
      expect {
        subject.perform_now
      }.to change(Report, :count).by(1)

      report = Report.find_by(identifier: "course_lesson_data")

      data = CSV.parse(report.data, headers: :first_row).map(&:to_h).map(&:symbolize_keys)
      expect(data.first).to match({
        "core_induction_programmes.id": a_string_matching(UUID_REGEX),
        "core_induction_programmes.name": "Test Core induction programme",
        "course_years.title": "Test Course year",
        "course_modules.id": a_string_matching(UUID_REGEX),
        "course_modules.title": "Test Course module",
        "course_lessons.id": a_string_matching(UUID_REGEX),
        "course_lessons.title": "Test Course lesson 1",
        "course_lessons_parts.id": a_string_matching(UUID_REGEX),
        "course_lessons_parts.title": "Test Course lesson part",
      })
    end

    context "when run more that once" do
      it "only creates one record" do
        expect {
          subject.perform_now
          subject.perform_now
        }.to change(Report, :count).by(1)
      end
    end
  end
end
