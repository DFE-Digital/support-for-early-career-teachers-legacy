# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseLessonPartPolicy, type: :policy do
  subject { described_class.new(user, course_lesson_part) }
  let(:course_lesson_part) { create(:course_lesson_part, course_lesson: course_lesson) }
  let(:course_lesson) { create(:course_lesson, course_module: course_module) }
  let(:course_module) { create(:course_module, course_year: course_year) }
  let(:course_year) { create(:course_year) }
  let(:cip_for_lesson_part) { create(:core_induction_programme, course_year_two: course_year) }

  context "admin user" do
    let(:user) { create(:user, :admin) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action(:show_split) }
    it { is_expected.to permit_action(:split) }

    describe "when there is > 1 course lesson part" do
      before :each do
        FactoryBot.create(:course_lesson_part, course_lesson: course_lesson_part.course_lesson)
      end

      it "permits the show_delete" do
        is_expected.to permit_action(:show_delete)
      end

      it "permits the destroy action" do
        is_expected.to permit_action(:destroy)
      end
    end

    describe "when there is 1 course lesson part" do
      it { is_expected.to forbid_action(:show_delete) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context "ect with access" do
    let(:user) { create(:user, :early_career_teacher, core_induction_programme: cip_for_lesson_part) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:show_split) }
    it { is_expected.to forbid_action(:split) }
    it { is_expected.to forbid_action(:show_delete) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "ect without access" do
    let(:user) { create(:user, :early_career_teacher) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:show_split) }
    it { is_expected.to forbid_action(:split) }
    it { is_expected.to forbid_action(:show_delete) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being a visitor" do
    let(:user) { nil }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:show_split) }
    it { is_expected.to forbid_action(:split) }
    it { is_expected.to forbid_action(:show_delete) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
