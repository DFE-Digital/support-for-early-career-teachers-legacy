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

    describe "GET /mentor-material-parts/:id" do
      it "renders the mentor material part page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to render_template(:show)
      end
    end

    describe "GET /mentor-material-parts/:id/edit" do
      it "renders the mentor material part edit page" do
        get "/mentor-material-parts/#{mentor_material_part.id}/edit"
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT /mentor-material-parts/:id" do
      it "renders a preview of changes to mentor material part" do
        put "/mentor-material-parts/#{mentor_material_part.id}", params: { commit: "See preview", content: "Extra content" }
        expect(response).to render_template(:edit)
        expect(response.body).to include("Extra content")
        mentor_material_part.reload
        expect(mentor_material_part.content).not_to include("Extra content")
      end

      it "redirects to the mentor material part page when saving content and title" do
        put "/mentor-material-parts/#{mentor_material_part.id}", params: { commit: "Save changes", content: "Adding new content", title: "New title" }
        expect(response).to redirect_to(mentor_material_part_path)
        get mentor_material_part_path
        expect(response.body).to include("Adding new content")
        expect(response.body).to include("New title")
      end
    end
  end

  describe "when an ect is logged in" do
    before do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = cip
      sign_in user
    end

    describe "GET /mentor-material-parts/:id" do
      it "throws an auth error for mentor material part page" do
        expect {
          get "/mentor-material-parts/#{mentor_material_part.id}"
        }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /mentor-material-parts/:id/edit" do
      it "raises an authorization error" do
        expect { get "/mentor-material-parts/#{mentor_material_part.id}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a mentor is logged in" do
    before do
      user = create(:user, :mentor)
      user.mentor_profile.core_induction_programme = cip
      sign_in user
    end

    describe "GET /mentor-material-parts/:id" do
      it "renders the mentor material part page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to render_template(:show)
      end
    end

    describe "GET /mentor-material-parts/:id/edit" do
      it "raises an authorization error" do
        expect { get "/mentor-material-parts/#{mentor_material_part.id}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a non-user is accessing the mentor material part page" do
    describe "GET /mentor-material-parts/:id" do
      it "redirects to the sign in page" do
        get "/mentor-material-parts/#{mentor_material_part.id}"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /mentor-material-parts/:id/edit" do
      it "redirects to the sign in page" do
        get "/mentor-material-parts/#{mentor_material_part.id}/edit"
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
