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
    let(:ect) { create(:user, :early_career_teacher) }
    let(:invite_email_ect) { InviteEmailEct.create!(user: ect) }

    context "before cut off date" do
      before do
        travel_to InviteEmailEct::INVITES_SENT_FROM - 2.days
      end

      it "does not send the email" do
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
        expect(invite_email_ect.notify_id).to be_nil
        expect(invite_email_ect.sent_to).to be_nil
      end
    end

    context "on cutoff date" do
      before do
        travel_to InviteEmailEct::INVITES_SENT_FROM
      end

      it "sends the email" do
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_truthy
        expect(invite_email_ect.notify_id).to eq("test_id")
        expect(invite_email_ect.sent_to).to eq(invite_email_ect.user.email)
      end
    end

    context "after cutoff date" do
      before do
        travel_to InviteEmailEct::INVITES_SENT_FROM + 2.days
      end

      it "sends the email" do
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_truthy
        expect(invite_email_ect.notify_id).to eq("test_id")
        expect(invite_email_ect.sent_to).to eq(invite_email_ect.user.email)
      end

      it "does not send the email to a full induction programme ect user" do
        ect.early_career_teacher_profile.full_induction_programme!
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
      end
    end
  end

  describe "sending mentor invite" do
    let(:mentor) { create(:user, :mentor) }
    let(:invite_email_mentor) { InviteEmailMentor.create!(user: mentor) }

    context "before cut off date" do
      before do
        travel_to InviteEmailMentor::INVITES_SENT_FROM - 2.days
      end

      it "does not send the email" do
        invite_email_mentor.send!
        expect(invite_email_mentor.reload.sent?).to be_falsey
        expect(invite_email_mentor.notify_id).to be_nil
        expect(invite_email_mentor.sent_to).to be_nil
      end
    end

    context "on cutoff date" do
      before do
        travel_to InviteEmailMentor::INVITES_SENT_FROM
      end

      it "sends the email" do
        invite_email_mentor.send!
        expect(invite_email_mentor.reload.sent?).to be_truthy
        expect(invite_email_mentor.notify_id).to eq("test_id")
        expect(invite_email_mentor.sent_to).to eq(invite_email_mentor.user.email)
      end

      it "does not send the email to a full induction programme mentor user" do
        mentor.mentor_profile.full_induction_programme!
        invite_email_mentor.send!
        expect(invite_email_mentor.reload.sent?).to be_falsey
      end
    end

    context "after cutoff date" do
      before do
        travel_to InviteEmailMentor::INVITES_SENT_FROM + 2.days
      end

      it "sends the email" do
        invite_email_mentor.send!
        expect(invite_email_mentor.reload.sent?).to be_truthy
        expect(invite_email_mentor.notify_id).to eq("test_id")
        expect(invite_email_mentor.sent_to).to eq(invite_email_mentor.user.email)
      end
    end
  end
end
