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
    it { is_expected.to have_many(:mentor_materials) }
    it { is_expected.to belong_to(:course_module) }
    it { is_expected.to have_one(:next_lesson) }
    it { is_expected.to belong_to(:previous_lesson).optional }
    it { is_expected.to have_many(:course_lesson_parts) }
  end

  describe "validations" do
    subject { FactoryBot.create(:course_lesson) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_length_of(:mentor_title).is_at_most(255) }
    it { is_expected.to validate_numericality_of(:completion_time_in_minutes).is_greater_than(0).with_message("Enter a number greater than 0") }
  end

  describe ".duration_in_minutes_in_words" do
    before :each do
      @course_lesson = FactoryBot.create(:course_lesson)
    end

    it "returns an integer < 60 converted to words showing just minutes" do
      @course_lesson.completion_time_in_minutes = 55
      expect(@course_lesson.duration_in_minutes_in_words).to eql("55 minutes")
    end

    it "returns an integer > 59 & < 120 converted to words showing the singular of hour and minute" do
      @course_lesson.completion_time_in_minutes = 61
      expect(@course_lesson.duration_in_minutes_in_words).to eql("1 hour 1 minute")
    end

    it "returns hours and minutes pluralized" do
      @course_lesson.completion_time_in_minutes = 122
      expect(@course_lesson.duration_in_minutes_in_words).to eql("2 hours 2 minutes")
    end

    it "returns only the hour when there is 0 minutes" do
      @course_lesson.completion_time_in_minutes = 60
      expect(@course_lesson.duration_in_minutes_in_words).to eql("1 hour")
    end

    it "returns hours pluralized and only the hours when there is 0 minutes" do
      @course_lesson.completion_time_in_minutes = 120
      expect(@course_lesson.duration_in_minutes_in_words).to eql("2 hours")
    end
  end

  describe "#title_for" do
    subject { FactoryBot.create(:course_lesson, title: "Normal title", mentor_title: "Mentor title") }

    it "is expected to return normal title for admins" do
      user = create(:user, :admin)
      expect(subject.title_for(user)).to eq "Normal title"
    end

    it "is expected to return mentor title for mentors" do
      user = create(:user, :mentor)
      expect(subject.title_for(user)).to eq "Mentor title"
    end

    it "is expected to return normal title for mentors when no mentor title" do
      lesson = create(:course_lesson, title: "Normal title")
      user = create(:user, :mentor)
      expect(lesson.title_for(user)).to eq "Normal title"
    end

    it "is expected to return normal title for ECTs" do
      user = create(:user, :early_career_teacher)
      expect(subject.title_for(user)).to eq "Normal title"
    end
  end

  describe "#teacher_standards_for" do
    subject { FactoryBot.create(:course_lesson, ect_teacher_standards: "Normal standards", mentor_teacher_standards: "Mentor standards") }

    it "is expected to return normal standards for admins" do
      user = create(:user, :admin)
      expect(subject.teacher_standards_for(user)).to eq "Normal standards"
    end

    it "is expected to return mentor standards for mentors" do
      user = create(:user, :mentor)
      expect(subject.teacher_standards_for(user)).to eq "Mentor standards"
    end

    it "is expected to return normal standards for mentors when no mentor standards" do
      lesson = create(:course_lesson, ect_teacher_standards: "Normal standards")
      user = create(:user, :mentor)
      expect(lesson.teacher_standards_for(user)).to eq "Normal standards"
    end

    it "is expected to return normal standards for ECTs" do
      user = create(:user, :early_career_teacher)
      expect(subject.teacher_standards_for(user)).to eq "Normal standards"
    end
  end
end
