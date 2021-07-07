# frozen_string_literal: true

require "rails_helper"

RSpec.describe CourseLessonPolicy, type: :policy do
  subject { described_class.new(user, course_lesson) }
  let(:course_lesson) { create(:course_lesson, course_module: course_module) }
  let(:course_module) { create(:course_module, course_year: course_year) }
  let(:course_year) { create(:course_year) }
  let(:cip_for_lesson) { course_year.core_induction_programme }

  context "admin user" do
    let(:user) { create(:user, :admin) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to forbid_action(:update_progress) }
  end

  context "ect with access" do
    let(:user) do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = cip_for_lesson
      user
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to permit_action(:update_progress) }
  end

  context "ect without access" do
    let(:user) { create(:user, :early_career_teacher) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to permit_action(:update_progress) }
  end

  context "mentor with access" do
    let(:user) do
      user = create(:user, :mentor)
      user.mentor_profile.core_induction_programme = cip_for_lesson
      user
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:update_progress) }
  end

  context "mentor without access" do
    let(:user) { create(:user, :mentor) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:update_progress) }
  end

  context "being a visitor" do
    let(:user) { nil }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:update_progress) }
  end
end
