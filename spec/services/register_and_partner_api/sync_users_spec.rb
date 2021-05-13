# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegisterAndPartnerApi::SyncUsers do
  describe "::perform" do
    before do
      stub_request(:get, "https://api.example.com/api/v1/users.json")
        .with(
          headers: {
            "Accept" => "application/json,*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v1.3.0",
          },
        ).to_return(status: 200, body: file_fixture("api/users.json").read, headers: { content_type: "application/json" })
    end

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

      record = User.find("f750b841-a97c-48b5-b29d-e758c7bdd7a1")
      expect(record.full_name).to eql("Induction Tutor")
      expect(record.email).to eql("induction-tutor@example.com")
    end
  end
end
