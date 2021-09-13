# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Core Induction Programme Year", type: :request do
  let(:course_year) { FactoryBot.create(:course_year) }
  let(:course_year_path) { "/#{cip.to_param}/#{course_year.to_param}" }
  let!(:cip) { course_year.core_induction_programme }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /years/:id" do
      it "renders the years show page" do
        get course_year_path
        expect(response).to render_template(:show)
      end
    end

    describe "GET /:cip_id/create-year" do
      it "renders the cip new years page" do
        get "/#{cip.to_param}/create-year"
        expect(response).to render_template(:new)
      end
    end

    describe "POST /:cip_id/create-year" do
      it "creates a new year, redirecting to the cip page" do
        create_course_year
        expect(response.location).to match("/test-cip-")
      end
    end

    describe "GET /years/:id/edit" do
      it "render the cip years edit page" do
        get "#{course_year_path}/edit", params: { course_year: { id: course_year.id } }
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT /years/:id" do
      it "renders a preview of changes to a year" do
        put course_year_path, params: { commit: "See preview", course_year: { content: "Extra content" } }
        expect(response).to render_template(:edit)
        expect(response.body).to include("Extra content")
        course_year.reload
        expect(course_year.content).not_to include("Extra content")
      end

      it "redirects to the year page and updates content when saving changes" do
        put course_year_path, params: { commit: "Save changes", course_year: { content: "Adding new content" } }
        expect(response).to redirect_to("/#{cip.to_param}/#{course_year.to_param}")
        expect(course_year.reload.content).to include("Adding new content")
      end
    end
  end

  describe "when an ect is logged in" do
    before do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = cip
      sign_in user
    end

    describe "GET /:cip_id/create-year" do
      it "raises an error when trying to create a new year page" do
        expect { get "/#{cip.to_param}/create-year" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "POST /years" do
      it "raises an error when trying to post a new year" do
        expect { create_course_year }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /years/:id/edit" do
      it "raises an error when trying to access edit page" do
        expect { get "#{course_year_path}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a visitor is accessing the year page" do
    describe "GET /years/new" do
      it "raises an error when trying to create a new year page" do
        get "/#{cip.to_param}/new"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "POST /:cip_id/create-year" do
      it "raises an error when trying to post a new year" do
        expect(create_course_year).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /years/:id/edit" do
      it "redirects to the sign in page" do
        get "#{course_year_path}/edit"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "PUT /years/:id" do
      it "redirects to the sign in page" do
        put course_year_path, params: { commit: "Save changes", content: course_year.content }
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

private

  def create_course_year
    post "/#{cip.to_param}/create-year", params: { course_year: {
      title: "Additional year title",
      content: "Additional year content",
    } }
  end
end
