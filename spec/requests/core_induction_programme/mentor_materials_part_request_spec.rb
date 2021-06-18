# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MentorMaterialsParts", type: :request do
  let(:course_lesson) { mentor_material_part.mentor_material.course_lesson }
  let(:course_module) { course_lesson.course_module }
  let(:course_year) { course_module.course_year }
  let(:cip) { FactoryBot.create(:core_induction_programme, course_year_one: course_year) }
  let(:mentor_material_part) { FactoryBot.create(:mentor_material_part) }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /module-material-parts/:id" do
      it "renders the module material part page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to render_template(:show)
      end
    end
  end

  describe "when an ect is logged in" do
    before do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = cip
      sign_in user
    end

    describe "GET /module-material-parts/:id" do
      it "throws an auth error for module material part page" do
        expect {
          get "/mentor-material-parts/#{mentor_material_part.id}"
        }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a mentor is logged in" do
    before do
      user = create(:user, :mentor)
      user.mentor_profile.core_induction_programme = cip
      sign_in user
    end

    describe "GET /module-material-parts/:id" do
      it "renders the module material part page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to render_template(:show)
      end
    end
  end

  describe "when a non-user is accessing the lesson part page" do
    describe "GET /module-material-parts/:id" do
      it "redirects to the sign in page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
