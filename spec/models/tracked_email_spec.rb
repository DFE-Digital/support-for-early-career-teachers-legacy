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

    context "email sending is disabled" do
      before do
        allow(ENV).to receive(:[]).with("EMAIL_SENDING_ENABLED").and_return("false")
      end

      it "does not send the email" do
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
        expect(invite_email_ect.notify_id).to be_nil
        expect(invite_email_ect.sent_to).to be_nil
      end

      it "sends the email if forced" do
        invite_email_ect.send!(force_send: true)
        expect(invite_email_ect.reload.sent?).to be_truthy
        expect(invite_email_ect.notify_id).to eq("test_id")
        expect(invite_email_ect.sent_to).to eq(invite_email_ect.user.email)
      end

      it "does not send the email to a full induction programme ect user even if forced" do
        ect.early_career_teacher_profile.full_induction_programme!
        invite_email_ect.send!(force_send: true)
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "does not send the email to a cip ect user without cip even if forced" do
        ect.early_career_teacher_profile.update!(core_induction_programme: nil)
        invite_email_ect.send!(force_send: true)
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "sends the email to a cip ect user if they have not completed registration, if forced" do
        ect.early_career_teacher_profile.update!(registration_completed: false)
        invite_email_ect.send!(force_send: true)
        expect(invite_email_ect.reload.sent?).to be_truthy
      end
    end

    context "when email sending is enabled" do
      before do
        allow(ENV).to receive(:[]).with("EMAIL_SENDING_ENABLED").and_return("true")
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

      it "does not send the email to ect if programme has no ects" do
        ect.early_career_teacher_profile.no_early_career_teachers!
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "does not send the email to ect if programme is being designed" do
        ect.early_career_teacher_profile.design_our_own!
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "does not send the email to ect if induction programme is not yet known" do
        ect.early_career_teacher_profile.not_yet_known!
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "does not send the email to a cip ect user if they have not completed registration" do
        ect.early_career_teacher_profile.update!(registration_completed: false)
        invite_email_ect.send!
        expect(invite_email_ect.reload.sent?).to be_falsey
      end

      it "sends only one email" do
        invite_email_ect.send!
        time = invite_email_ect.sent_at

        travel_to(1.hour.from_now) do
          invite_email_ect.send!
          expect(invite_email_ect.reload.sent_at).to be_within(1.second).of time
        end
      end

      context "the user is nqt+1" do
        let(:ect) { create(:user, :early_career_teacher, cohort_year: 2020, registration_completed: false) }

        it "sends the ect welcome email" do
          expect(UserMailer).to receive(:nqt_plus_one_welcome_email).with(ect).and_call_original
          invite_email_ect.send!
          expect(invite_email_ect.reload.sent?).to be_truthy
          expect(invite_email_ect.notify_id).to eq("test_id")
          expect(invite_email_ect.sent_to).to eq(ect.email)
        end
      end
    end
  end

  describe "sending mentor invite" do
    let(:mentor) { create(:user, :mentor) }
    let(:invite_email_mentor) { InviteEmailMentor.create!(user: mentor) }

    context "when email sending is disabled" do
      before do
        allow(ENV).to receive(:[]).with("EMAIL_SENDING_ENABLED").and_return("false")
      end

      it "does not send the email" do
        invite_email_mentor.send!
        expect(invite_email_mentor.reload.sent?).to be_falsey
        expect(invite_email_mentor.notify_id).to be_nil
        expect(invite_email_mentor.sent_to).to be_nil
      end

      it "sends the email if forced" do
        invite_email_mentor.send!(force_send: true)
        expect(invite_email_mentor.reload.sent?).to be_truthy
        expect(invite_email_mentor.notify_id).to eq("test_id")
        expect(invite_email_mentor.sent_to).to eq(invite_email_mentor.user.email)
      end

      it "does not send the email to a full induction programme mentor user even if forced" do
        mentor.mentor_profile.full_induction_programme!
        invite_email_mentor.send!(force_send: true)
        expect(invite_email_mentor.reload.sent?).to be_falsey
      end

      it "does not send the email to a cip mentor without cip user even if forced" do
        mentor.mentor_profile.update!(core_induction_programme: nil)
        invite_email_mentor.send!(force_send: true)
        expect(invite_email_mentor.reload.sent?).to be_falsey
      end

      it "sends the email to a cip mentor if they have not completed registration, if forced" do
        mentor.mentor_profile.update!(registration_completed: false)
        invite_email_mentor.send!(force_send: true)
        expect(invite_email_mentor.reload.sent?).to be_truthy
      end
    end

    context "when email sending is enabled" do
      context "before cut off date" do
        before do
          allow(ENV).to receive(:[]).with("EMAIL_SENDING_ENABLED").and_return("true")
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

        it "does not send the email to a mentor if programme has no ects" do
          mentor.mentor_profile.no_early_career_teachers!
          invite_email_mentor.send!
          expect(invite_email_mentor.reload.sent?).to be_falsey
        end

        it "does not send the email to mentor if programme is being designed" do
          mentor.mentor_profile.design_our_own!
          invite_email_mentor.send!
          expect(invite_email_mentor.reload.sent?).to be_falsey
        end

        it "does not send the email to mentor if induction programme is not yet known" do
          mentor.mentor_profile.not_yet_known!
          invite_email_mentor.send!
          expect(invite_email_mentor.reload.sent?).to be_falsey
        end

        it "does not send the email to a cip mentor if they have not completed registration" do
          mentor.mentor_profile.update!(registration_completed: false)
          invite_email_mentor.send!
          expect(invite_email_mentor.reload.sent?).to be_falsey
        end
      end
    end
  end
end
