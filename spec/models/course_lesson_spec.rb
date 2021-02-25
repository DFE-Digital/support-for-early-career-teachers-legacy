# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseLesson, type: :model do
  it "can be created" do
    expect {
      CourseLesson.create(
        title: "Test Course lesson",
        course_module: FactoryBot.create(:course_module),
        completion_time_in_minutes: 10,
      )
    }.to change { CourseLesson.count }.by(1)
  end

  describe "associations" do
    it { is_expected.to belong_to(:course_module) }
    it { is_expected.to have_one(:next_lesson) }
    it { is_expected.to belong_to(:previous_lesson).optional }
    it { is_expected.to have_many(:course_lesson_parts) }
  end

  describe "validations" do
    subject { FactoryBot.create(:course_lesson) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_numericality_of(:completion_time_in_minutes).is_greater_than_or_equal_to(1).with_message("Enter a number greater than 0") }
  end
end
