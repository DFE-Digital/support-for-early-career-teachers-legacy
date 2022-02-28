# frozen_string_literal: true

require "rails_helper"

RSpec.describe InviteParticipants do
  let(:ect) { create(:user, :early_career_teacher) }
  let(:mentor) { create(:user, :mentor) }
  let(:external_user) { create(:user, :external_user) }

  describe "#run" do
    context "when no emails exist previously" do
      it "creates an ECT email when given ECT user" do
        expect { InviteParticipants.run([ect.email]) }.to change { InviteEmailEct.count }.by(1)
      end

      it "creates an mentor email when given mentor user" do
        expect { InviteParticipants.run([mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
      end

      it "creates a ect email when given an ect and a mentor" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.to change { InviteEmailEct.count }.by(1)
      end

      it "creates a mentor email when given an ect and a mentor" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
      end

      it "creates an external user email when given an external user" do
        expect { InviteParticipants.run([external_user.email]) }.to change { InviteEmailExternalUser.count }.by(1)
      end
    end

    context "when unsent emails exist" do
      before do
        InviteEmailEct.create!(user: ect)
        InviteEmailMentor.create!(user: mentor)
      end

      it "does not create an email for ect" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.not_to(change { InviteEmailEct.count })
      end

      it "does not create an email for mentor" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.not_to(change { InviteEmailMentor.count })
      end
    end

    context "when sent emails exist" do
      before do
        InviteEmailEct.create!(user: ect, sent_at: Time.zone.now)
        InviteEmailMentor.create!(user: mentor, sent_at: Time.zone.now)
        InviteEmailExternalUser.create!(user: external_user, sent_at: Time.zone.now)
      end

      it "does not create an email for ect" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.not_to(change { InviteEmailMentor.count })
      end

      it "does not create an email for mentor" do
        expect { InviteParticipants.run([ect.email, mentor.email]) }.not_to(change { InviteEmailMentor.count })
      end

      it "does create an email for the external user" do
        expect { InviteParticipants.run([external_user.email]) }.to(change { InviteEmailExternalUser.count }.by(1))
      end
    end

    it "does not stop when it gets an invalid email" do
      expect { InviteParticipants.run(["invalid_email", mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
    end

    it "does not create any emails when given invalid email" do
      expect { InviteParticipants.run(%w[invalid_email]) }.not_to(change { TrackedEmail.count })
    end
  end
end
