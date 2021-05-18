# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TrainingAndSupports", type: :request do
  describe "GET /show" do
    before do
      early_career_teacher = create(:user, :early_career_teacher)
      sign_in early_career_teacher
    end

    it "returns http success" do
      get "/training-and-support"
      expect(response).to render_template(:show)
    end
  end
end
