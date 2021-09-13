# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorMaterialPolicy, type: :policy do
  subject { described_class.new(user, mentor_material) }
  let(:mentor_material) { create(:mentor_material) }

  context "as admin" do
    let(:user) { create(:user, :admin) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_new_and_create_actions }
  end

  context "as a user" do
    let(:user) { create(:user) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_new_and_create_actions }
  end

  context "as a visitor" do
    let(:user) { nil }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_new_and_create_actions }
  end

  context "as a mentor with the right CIP" do
    let(:user) { create(:user, :mentor) }

    before do
      user.mentor_profile.update!(core_induction_programme: mentor_material.core_induction_programme)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_new_and_create_actions }
  end

  context "as a mentor with the wrong CIP" do
    let(:user) { create(:user, :mentor) }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_new_and_create_actions }
  end
end
