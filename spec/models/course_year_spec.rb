# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseYear, type: :model do
  it "can be created" do
    expect {
      CourseYear.create(
        title: "Test Course year",
        content: "No content",
      )
    }.to change { CourseYear.count }.by(1)
  end

  describe "associations" do
    it { is_expected.to have_many(:course_modules) }
    it { is_expected.to have_one(:core_induction_programme_one) }
    it { is_expected.to have_one(:core_induction_programme_two) }
  end

  describe "validations" do
    subject { FactoryBot.create(:course_year) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_length_of(:mentor_title).is_at_most(255) }
    it { is_expected.to validate_length_of(:content).is_at_most(100_000) }
  end

  describe "#title_for" do
    subject { FactoryBot.create(:course_year, title: "Normal title", mentor_title: "Mentor title") }

    it "is expected to return normal title for admins" do
      user = create(:user, :admin)
      expect(subject.title_for(user)).to eq "Normal title"
    end

    it "is expected to return mentor title for mentors" do
      user = create(:user, :mentor)
      expect(subject.title_for(user)).to eq "Mentor title"
    end

    it "is expected to return normal title for mentors when no mentor title" do
      year = create(:course_year, title: "Normal title")
      user = create(:user, :mentor)
      expect(year.title_for(user)).to eq "Normal title"
    end

    it "is expected to return normal title for ECTs" do
      user = create(:user, :early_career_teacher)
      expect(subject.title_for(user)).to eq "Normal title"
    end
  end

  describe "course_modules" do
    before :each do
      @teacher = FactoryBot.create(:user, :early_career_teacher)

      @course_year = FactoryBot.create(:course_year)
      @course_module_one = FactoryBot.create(:course_module, title: "One", course_year: @course_year, term: "summer")
      @course_lesson_one = FactoryBot.create(:course_lesson, :with_lesson_part, course_module: @course_module_one)
      @course_lesson_two = FactoryBot.create(:course_lesson, :with_lesson_part, course_module: @course_module_one)

      @course_lesson_one_progress = FactoryBot.create(
        :course_lesson_progress, course_lesson: @course_lesson_one, early_career_teacher_profile: @teacher.early_career_teacher_profile
      )
      @course_lesson_two_progress = FactoryBot.create(
        :course_lesson_progress, course_lesson: @course_lesson_two, early_career_teacher_profile: @teacher.early_career_teacher_profile
      )
    end

    it "returns modules in order after they get updated" do
      course_module_two = FactoryBot.create(:course_module, title: "Two", course_year: @course_year, term: "spring")
      course_module_three = FactoryBot.create(:course_module, title: "Three", course_year: @course_year, term: "spring")
      course_module_four = FactoryBot.create(:course_module, title: "Four", course_year: @course_year, term: "spring")

      course_module_two.update!(previous_module: @course_module_one)
      course_module_four.update!(previous_module: course_module_two)
      course_module_three.update!(previous_module: course_module_four)

      expected_modules_in_order = [@course_module_one, course_module_two, course_module_four, course_module_three]
      @course_year.course_modules_in_order.zip(expected_modules_in_order).each do |actual, expected|
        expect(actual).to eq(expected)
      end

      expected_spring_modules = [course_module_two, course_module_four, course_module_three]
      @course_year.spring_modules_with_progress(@teacher).zip(expected_spring_modules).each do |actual, expected|
        expect(actual).to eq(expected)
      end
    end

    it "returns a progress of to_do when all lessons in that module are to_do" do
      module_progress = @course_year.modules_with_progress(@teacher).first
      expect(module_progress.progress).to eql("to_do")
    end

    it "returns a progress of in_progress when one lesson in that module is in_progress" do
      @course_lesson_one_progress.in_progress!

      module_progress = @course_year.modules_with_progress(@teacher).first
      expect(module_progress.progress).to eql("in_progress")
    end

    it "returns a progress of complete when all lessons in that module are complete" do
      @course_lesson_one_progress.complete!
      @course_lesson_two_progress.complete!

      module_progress = @course_year.modules_with_progress(@teacher).first
      expect(module_progress.progress).to eql("complete")
    end

    it "returns a progress of complete when all lessons with content in that module are complete" do
      @course_lesson_one_progress.complete!
      @course_lesson_two_progress.complete!

      FactoryBot.create(:course_lesson, course_module: @course_module_one)

      module_progress = @course_year.modules_with_progress(@teacher).first
      expect(module_progress.progress).to eql("complete")
    end
  end
end
