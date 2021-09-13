# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserLoginDataReportJob do
  describe "#perform" do
    it "persists report record" do
      user = create(:user)
      expect {
        subject.perform_now
      }.to change(Report, :count).by(1)

      report = Report.find_by(identifier: "user_login_data")

      data = CSV.parse(report.data, headers: :first_row).map(&:to_h).map(&:symbolize_keys)
      expect(data.first).to match(
        hash_including(
          "users.id": user.id,
          "users.register_and_partner_id": user.register_and_partner_id,
          "users.last_sign_in_at": user.last_sign_in_at,
          "users.sign_in_count": user.sign_in_count,
        ),
      )
    end

    context "when the user is a mentor" do
      it "includes the mentor profile id" do
        user = create(:user, :mentor)
        expect {
          subject.perform_now
        }.to change(Report, :count).by(1)

        report = Report.find_by(identifier: "user_login_data")

        data = CSV.parse(report.data, headers: :first_row).map(&:to_h).map(&:symbolize_keys)
        expect(data.first).to match(
          hash_including(
            "early_career_teacher_profiles.id": nil,
            "mentor_profiles.id": user.mentor_profile.id,
          ),
        )
      end
    end

    context "when the user is an ect" do
      it "includes the ect profile id" do
        user = create(:user, :early_career_teacher)
        expect {
          subject.perform_now
        }.to change(Report, :count).by(1)

        report = Report.find_by(identifier: "user_login_data")

        data = CSV.parse(report.data, headers: :first_row).map(&:to_h).map(&:symbolize_keys)
        expect(data.first).to match(
          hash_including(
            "early_career_teacher_profiles.id": user.early_career_teacher_profile.id,
            "mentor_profiles.id": nil,
          ),
        )
      end
    end

    context "when run more that once" do
      it "only creates one record" do
        expect {
          subject.perform_now
          subject.perform_now
        }.to change(Report, :count).by(1)
      end
    end
  end
end
