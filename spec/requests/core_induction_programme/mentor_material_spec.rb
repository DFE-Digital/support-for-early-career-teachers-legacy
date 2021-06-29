# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mentor materials", type: :request do
  let(:mentor_material) { create(:mentor_material, :with_mentor_material_part) }
  let(:first_part) { mentor_material.mentor_material_parts_in_order[0] }
  let(:course_lesson) { mentor_material.course_lesson }
  let(:course_module) { course_lesson.course_module }
  let(:course_year) { course_module.course_year }
  let(:cip) { create(:core_induction_programme, course_year_one: course_year) }

  let(:course_lesson_path) { "/#{cip.to_param}/#{course_year.to_param}/#{course_module.to_param}/#{course_lesson.to_param}" }
  let(:mentor_material_path) { "#{course_lesson_path}/mentoring/#{mentor_material.id}" }
  let(:mentor_material_part_path) { "#{course_lesson_path}/mentoring/#{mentor_material.id}/#{first_part.to_param}" }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /mentor-materials" do
      it "renders index template" do
        get "/mentor-materials"
        expect(response).to render_template(:index)
      end
    end

    describe "GET /mentor-materials/:id" do
      it "redirect to part" do
        get "/mentor-materials/#{mentor_material.id}"
        expect(response).to redirect_to(mentor_material_part_path)
      end
    end

    describe "PUT /mentor-materials/:id" do
      it "redirects to the first part" do
        put mentor_material_path, params: { commit: "Save", mentor_material: { title: "New title" } }
        expect(response).to redirect_to(mentor_material_path)
        get mentor_material_part_path
        expect(response.body).to include("New title")
      end
    end

    describe "GET /mentor-materials/:id/edit" do
      it "renders the mentor materials edit page" do
        get "#{mentor_material_path}/edit", params: { mentor_material: { id: mentor_material.id } }
        expect(response).to render_template(:edit)
      end
    end

    describe "GET /mentor-materials/new" do
      it "renders new template" do
        get "/mentor-materials/new"
        expect(response).to render_template(:new)
      end
    end

    describe "POST /mentor-materials" do
      it "creates a mentor material" do
        expect {
          post mentor_materials_path, params: { mentor_material: { title: "New title" } }
        }.to(change { MentorMaterial.count }.by(1))
      end
    end
  end

  describe "when a non-admin user is logged in" do
    before do
      user = create(:user)
      sign_in user
    end

    describe "GET /mentor-materials" do
      it "raises an error" do
        expect { get "/mentor-materials" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /mentor-materials/:id" do
      it "raises an error" do
        expect { get "/mentor-materials/#{mentor_material.id}" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /mentor-materials/:id/edit" do
      it "raises an error" do
        expect { get "#{mentor_material_path}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "PUT /mentor-materials/:id" do
      it "raises an error" do
        expect { put mentor_material_path, params: { commit: "Save" } }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a non-user is accessing the mentor material page" do
    describe "GET /mentor-materials" do
      it "raises an error when trying to access mentor materials" do
        get "/mentor-materials"
        expect(mentor_material_path).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /mentor-materials/:id/edit" do
      it "redirects to the sign in page" do
        get "#{mentor_material_path}/edit"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "PUT /mentor-materials/:id" do
      it "redirects to the sign in page" do
        put mentor_material_path, params: { commit: "Save" }
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
