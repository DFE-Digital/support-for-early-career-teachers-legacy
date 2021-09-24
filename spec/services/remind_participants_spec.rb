# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemindParticipants do
  let(:mentor) { create(:user, :mentor) }
  let(:ect) { create(:user, :early_career_teacher) }

  describe "#run" do
    it "creates a mentor email when given mentor user" do
      expect { RemindParticipants.run([mentor.email]) }.to change { ReminderEmailMentor.count }.by(1)
    end

    it "does not create an email when given another user type" do
      expect { RemindParticipants.run([ect.email]) }.not_to(change { ReminderEmailMentor.count })
    end
  end
end
