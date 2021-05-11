# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseModule, type: :model do
  it "can be created" do
    expect {
      CourseModule.create(
        title: "Test Course module",
        ect_summary: "No content",
        course_year: FactoryBot.create(:course_year),
      )
    }.to change { CourseModule.count }.by(1)
  end

  describe "associations" do
    it { is_expected.to have_many(:mentor_materials) }
    it { is_expected.to belong_to(:course_year) }
    it { is_expected.to have_one(:next_module) }
    it { is_expected.to belong_to(:previous_module).optional }
    it { is_expected.to have_many(:course_lessons) }
  end

  describe "validations" do
    subject { FactoryBot.create(:course_module) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_presence_of(:ect_summary).with_message("Enter ECT summary") }
    it { is_expected.to validate_length_of(:ect_summary).is_at_most(100_000) }
  end

  describe "course_lessons" do
    it "returns lessons in correct order" do
      course_module = FactoryBot.create(:course_module)
      course_lesson_four = FactoryBot.create(:course_lesson, title: "Four", course_module: course_module, position: 4)
      course_lesson_one = FactoryBot.create(:course_lesson, title: "One", course_module: course_module, position: 1)
      course_lesson_three = FactoryBot.create(:course_lesson, title: "Three", course_module: course_module, position: 3)
      course_lesson_two = FactoryBot.create(:course_lesson, title: "Two", course_module: course_module, position: 2)

      expected_lessons_with_order = [course_lesson_one, course_lesson_two, course_lesson_three, course_lesson_four]
      course_module.course_lessons.zip(expected_lessons_with_order).each do |actual, expected|
        expect(actual).to eq(expected)
      end
    end

    describe "course_modules" do
      it "returns the term and title of a course module" do
        course_module = FactoryBot.create(:course_module)
        expect(course_module.term_and_title).to eq("Spring test course module")
      end
    end
  end
end
