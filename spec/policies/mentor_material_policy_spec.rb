# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorMaterialPolicy, type: :policy do
  subject { described_class.new(user, mentor_material) }
  let(:mentor_material) { create(:mentor_material) }

  context "editing as admin" do
    let(:user) { create(:user, :admin) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
  end

  context "trying to edit as a user" do
    let(:user) { create(:user) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context "being a visitor" do
    let(:user) { nil }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
