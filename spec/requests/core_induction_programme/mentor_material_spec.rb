# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mentor materials", type: :request do
  let(:mentor_material) { create(:mentor_material) }
  let(:mentor_material_path) { "/mentor-materials/#{mentor_material.id}" }

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
      it "renders show template" do
        get "/mentor-materials/#{mentor_material.id}"
        expect(response).to render_template(:show)
      end
    end

    describe "PUT /mentor-materials/:id" do
      it "redirects to the mentor materials" do
        put mentor_material_path, params: { commit: "Save changes", mentor_material: { title: "New title" } }
        expect(response).to redirect_to(mentor_material_path)
        get mentor_material_path
        expect(response.body).to include("New title")
      end
    end

    describe "GET /mentor-materials/:id/edit" do
      it "renders the mentor materials edit page" do
        get "#{mentor_material_path}/edit", params: { mentor_material: { id: mentor_material.id } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "when a non-admin user is logged in" do
    before do
      user = create(:user)
      sign_in user
    end

    describe "GET /mentor-materials" do
      it "renders index template" do
        get "/mentor-materials"
        expect(response).to render_template(:index)
      end
    end

    describe "GET /mentor-materials/:id" do
      it "renders the mentor materials show page" do
        get "/mentor-materials/#{mentor_material.id}"
        expect(response).to render_template(:show)
      end
    end

    describe "GET /mentor-materials/:id/edit" do
      it "raises an error when trying to access edit page" do
        expect { get "#{mentor_material_path}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "PUT /mentor-materials/:id" do
      it "redirects to the sign in page" do
        expect { put mentor_material_path, params: { commit: "Save changes", content: mentor_material.content } }.to raise_error Pundit::NotAuthorizedError
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
        put mentor_material_path, params: { commit: "Save changes", content: mentor_material.content }
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
