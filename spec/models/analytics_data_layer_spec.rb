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
    let(:user) { create(:user) }

    it "adds the user type to the analytics data" do
      data_layer.add_user_info(user)
      expect(data_layer.analytics_data[:userType]).to eq(user.user_description)
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
