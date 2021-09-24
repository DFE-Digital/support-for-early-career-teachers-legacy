# frozen_string_literal: true

require "rails_helper"

RSpec.describe StreamBigqueryCourseLessonProgressJob do
  let(:course_lesson_progress) { create(:course_lesson_progress) }

  describe "#perform" do
    let(:bigquery) { double("bigquery") }
    let(:dataset) { double("dataset") }
    let(:table) { double("table", insert: nil) }

    before do
      allow(Google::Cloud::Bigquery).to receive(:new).and_return(bigquery)
      allow(bigquery).to receive(:dataset).and_return(dataset)
      allow(dataset).to receive(:table).and_return(table)
    end

    it "sends correct data to BigQuery" do
      described_class.perform_now(course_lesson_progress)

      expect(table).to have_received(:insert).with([{
        "course_lesson_progresses_early_career_teacher_profile_id" => course_lesson_progress.early_career_teacher_profile_id,
        "course_lesson_progresses_course_lesson_id" => course_lesson_progress.course_lesson_id,
        "course_lesson_progresses_created_at" => course_lesson_progress.created_at,
        "course_lesson_progresses_updated_at" => course_lesson_progress.updated_at,
        "course_lesson_progresses_progress" => course_lesson_progress.progress,
      }])
    end
  end
end
