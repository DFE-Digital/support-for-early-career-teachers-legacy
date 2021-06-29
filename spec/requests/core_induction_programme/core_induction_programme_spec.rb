# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Core Induction Programme", type: :request do
  let!(:core_induction_programme) { create(:core_induction_programme, :with_course_year) }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /providers" do
      it "renders the core_induction_programmes page" do
        get "/providers"
        expect(response).to render_template(:index)
      end
    end

    describe "GET /:id" do
      it "redirects to year page" do
        get "/#{core_induction_programme.to_param}"
        expect(response).to redirect_to("/#{core_induction_programme.to_param}/#{core_induction_programme.course_year_one.to_param}")
      end
    end
  end

  describe "when an early career teacher is logged in" do
    before do
      early_career_teacher = create(:user, :early_career_teacher)
      early_career_teacher.early_career_teacher_profile.core_induction_programme = core_induction_programme
      sign_in early_career_teacher
    end

    describe "GET /providers" do
      it "raises an error trying to access core_induction_programme index page" do
        expect { get "/providers" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /:id" do
      it "redirects to year page" do
        get "/#{core_induction_programme.to_param}"
        expect(response).to redirect_to("/#{core_induction_programme.to_param}/#{core_induction_programme.course_year_one.to_param}")
      end

      it "raises an error when an ECT tries to access a cip they are not enrolled on" do
        second_core_induction_programme = create(:core_induction_programme, slug: "nah")
        expect { get "/#{second_core_induction_programme.to_param}" }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "being a visitor" do
    it "raises an error trying to access core_induction_programme index page" do
      get "/providers"
      expect(response).to redirect_to("/users/sign_in")
    end

    it "renders the core_induction_programme show page" do
      get "/#{core_induction_programme.to_param}"
      expect(response).to redirect_to("/users/sign_in")
    end
  end

  describe "GET /download-export" do
    it "download export redirects to cip path when user is not admin" do
      get "/download-export"
      expect(response).to redirect_to("/users/sign_in")
    end

    it "download export downloads a file when user is admin" do
      create(:course_lesson)

      admin_user = create(:user, :admin)
      sign_in admin_user

      get "/download-export"
      expect(response.body).to include("CourseYear.import(")
      expect(response.body).to include("CourseModule.import(")
      expect(response.body).to include("CourseLesson.import(")
      expect(response.header["Content-Type"]).to eql "text/plain"
    end
  end
end
