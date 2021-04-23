# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TrainingAndSupports", type: :request do
  describe "GET /show" do
    before do
      cip = create(:core_induction_programme)
      early_career_teacher = create(:user, :early_career_teacher, { core_induction_programme: cip })
      sign_in early_career_teacher
    end

    it "returns http success" do
      get "/training-and-support"
      expect(response).to render_template(:show)
    end
  end
end
