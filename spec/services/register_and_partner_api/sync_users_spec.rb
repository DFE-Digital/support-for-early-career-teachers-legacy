# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegisterAndPartnerApi::SyncUsers do
  describe "::perform" do
    it "imports all users returned" do
      expect {
        described_class.perform
      }.to change(User, :count).by(3)
    end

    it "does not create the users again" do
      expect {
        described_class.perform
        described_class.perform
      }.to change(User, :count).by(3)
    end

    it "does not create a user when given a user type of other" do
      described_class.perform

      record = User.find_by(email: "user_type_other@example.com")
      expect(record.nil?).to be true
      expect(User.count).to eql(3)
    end

    it "creates users with correct attributes" do
      described_class.perform

      record = User.find_by(email: "school-leader@example.com")
      expect(record.full_name).to eql("Induction Tutor")
    end

    it "creates a user with a type of early_career_teacher" do
      described_class.perform

      record = User.find_by(email: "rp-ect-ambition@example.com")
      expect(record.early_career_teacher?).to be true
    end

    it "updates an existing user that has changed their email address" do
      create(:user, register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934", email: "mentor-1@example.com")

      described_class.perform

      record = User.find_by(register_and_partner_id: "65abf54c-c7c2-490b-9bcd-bbb4e0aab934")
      expect(User.count).to eql(3)
      expect(record.email).to eql("mentor@example.com")
    end

    it "creates an invite email for new mentors and early career teachers" do
      allow(InviteParticipants).to receive(:run)
      described_class.perform

      expect(InviteParticipants).to have_received(:run).with(["mentor@example.com"])
      expect(InviteParticipants).to have_received(:run).with(["school-leader@example.com"])
      expect(InviteParticipants).to have_received(:run).with(["rp-ect-ambition@example.com"])
    end

    it "does not create an invite email for old mentors and early career teachers" do
      described_class.perform

      allow(InviteParticipants).to receive(:run)
      described_class.perform
      expect(InviteParticipants).not_to have_received(:run)
    end
  end
end
