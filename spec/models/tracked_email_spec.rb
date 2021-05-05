# frozen_string_literal: true

require "rails_helper"

RSpec.describe TrackedEmail, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "sending generic email" do
    let(:tracked_email) { TrackedEmail.create!(user: create(:user)) }

    it "raises not implemented exceptions" do
      expect { tracked_email.send! }.to raise_error(NotImplementedError)
    end
  end

  describe "sending ect invite" do
    let(:invite_email_ect) { InviteEmailEct.create!(user: create(:user)) }

    it "sends the email" do
      invite_email_ect.send!
      expect(invite_email_ect.reload.sent?).to be_truthy
      expect(invite_email_ect.notify_id).to eq("test_id")
      expect(invite_email_ect.sent_to).to eq(invite_email_ect.user.email)
    end
  end
end
