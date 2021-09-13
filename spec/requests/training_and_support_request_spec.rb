# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TrainingAndSupports", type: :request do
  describe "GET /show" do
    before do
      cip = create(:core_induction_programme, name: "UCL")
      early_career_teacher = create(:user, :early_career_teacher)
      early_career_teacher.early_career_teacher_profile.core_induction_programme = cip
      sign_in early_career_teacher
    end

    it "returns http success" do
      get "/training-and-support"
      expect(response).to render_template(:show)
    end

    it "returns http success" do
      get "/guidance-question"
      expect(response).to render_template(:guidance_question)
    end

    it "redirects to the guidance show page" do
      post "/guidance-question", params: {
        commit: "Continue",
        guidance_speedbump_form: {
          view_guidance_option: "view_guidance",
        },
      }
      expect(response).to redirect_to("/training-and-support")
    end
  end
end
