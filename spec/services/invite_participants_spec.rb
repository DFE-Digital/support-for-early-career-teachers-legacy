# frozen_string_literal: true

require "rails_helper"

RSpec.describe InviteParticipants do
  let(:ect) { create(:user, :early_career_teacher) }
  let(:mentor) { create(:user, :mentor) }

  describe "#run" do
    it "creates an ECT email when given ECT user" do
      expect { InviteParticipants.run([ect.email]) }.to change { InviteEmailEct.count }.by(1)
    end

    it "creates an mentor email when given mentor user" do
      expect { InviteParticipants.run([mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
    end

    it "creates an an ect and a mentor email when given an ect and a mentor" do
      expect { InviteParticipants.run([ect.email, mentor.email]) }.to change { InviteEmailEct.count }.by(1)
      expect { InviteParticipants.run([ect.email, mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
    end

    it "does not stop when it gets an invalid email" do
      expect { InviteParticipants.run(["invalid_email", mentor.email]) }.to change { InviteEmailMentor.count }.by(1)
    end

    it "does not create any emails when given invalid email" do
      expect { InviteParticipants.run(%w[invalid_email]) }.not_to(change { TrackedEmail.count })
    end
  end
end
