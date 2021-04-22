# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TrainingAndSupports", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/training-and-support"
      expect(response).to have_http_status(:success)
      expect(response).to render(:show)
    end
  end
end
