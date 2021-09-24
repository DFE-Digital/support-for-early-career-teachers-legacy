# frozen_string_literal: true

require "rails_helper"

RSpec.describe StreamBigqueryUserLoginJob do
  let(:user) { create(:user) }

  describe "#perform" do
    let(:bigquery) { double("bigquery") }
    let(:dataset) { double("dataset") }
    let(:table) { double("table", insert: nil) }

    before do
      allow(Google::Cloud::Bigquery).to receive(:new).and_return(bigquery)
      allow(bigquery).to receive(:dataset).and_return(dataset)
      allow(dataset).to receive(:table).and_return(table)
    end

    it "sends correct data to BigQuery" do
      described_class.perform_now(user)

      expect(table).to have_received(:insert).with([{
        "users_id" => user.id,
        "users_register_and_partner_id" => user.register_and_partner_id,
        "users_last_sign_in_at" => user.last_sign_in_at,
        "users_sign_in_count" => user.sign_in_count,
        "early_career_teacher_profiles_id" => user.early_career_teacher_profile&.id,
        "mentor_profiles_id" => user.mentor_profile&.id,
      }])
    end
  end
end
