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
  end
end
