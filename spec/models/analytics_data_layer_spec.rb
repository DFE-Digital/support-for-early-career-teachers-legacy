# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnalyticsDataLayer, type: :model do
  subject(:data_layer) { described_class.new }

  describe "#add" do
    it "adds a hash to the analytics data" do
      data_layer.add(urn: "123456")

      expect(data_layer.analytics_data[:urn]).to eq("123456")
    end
  end

  describe "#add_user_info" do
    let(:user) { create(:user, :early_career_teacher) }
    let(:course_year) { create(:course_year) }

    it "adds the user type to the analytics data" do
      data_layer.add_user_info(user)
      expect(data_layer.analytics_data[:userType]).to eq(user.user_description)
    end

    it "adds the correct year to the analytics data" do
      data_layer.add_year_info(course_year)
      expect(data_layer.analytics_data[:cipYear]).to eq("Year #{course_year.position}")
    end

    it "adds the correct core induction programme name to the analytics data" do
      data_layer.add_user_info(user)
      expect(data_layer.analytics_data[:userCoreInductionProgramme]).to eq(user.core_induction_programme.name)
    end

    it "should add the correct cohort year to the analytics data" do
      user.early_career_teacher_profile.update!(cohort: create(:cohort, start_year: 2020))
      data_layer.add_user_info(user)
      expect(data_layer.analytics_data[:cohortStartYear]).to eq(user.cohort.start_year)
    end

    context "when the supplied user is nil" do
      it "does not add anything to the analytics data" do
        data_layer.add_user_info(nil)
        expect(data_layer.analytics_data.key?(:userType)).to be false
      end
    end
  end

  describe "#to_json" do
    before do
      data_layer.add(userType: "Mentor",
                     errors: { a: "error", b: "bad file" })
    end

    it "returns the analytics data as an array of key value pairs in JSON format" do
      result = JSON.parse(data_layer.to_json)
      expect(result).to match_array [{ "userType" => "Mentor" },
                                     { "errors" => { "a" => "error", "b" => "bad file" } }]
    end
  end
end
