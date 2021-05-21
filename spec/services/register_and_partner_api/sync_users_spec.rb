# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegisterAndPartnerApi::SyncUsers do
  describe "::perform" do
    it "imports all users returned" do
      expect {
        described_class.perform
      }.to change(User, :count).by(2)
    end

    it "does not create the users again" do
      expect {
        described_class.perform
        described_class.perform
      }.to change(User, :count).by(2)
    end

    it "creates users with correct attributes" do
      described_class.perform

      record = User.find_by(email: "school-leader@example.com")
      expect(record.full_name).to eql("Induction Tutor")
    end

    it "updates an existing user that has changed their email address" do
      create(:user, register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934", email: "lead-provider-1@example.com")

      described_class.perform

      record = User.find_by(register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934")
      expect(User.count).to eql(2)
      expect(record.email).to eql("lead-provider@example.com")
    end
  end
end
