# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Core Induction Programme Module", type: :request do
  let!(:course_year) { FactoryBot.create(:course_year) }
  let!(:core_induction_programme) { course_year.core_induction_programme }
  let(:course_module) { FactoryBot.create(:course_module, course_year: course_year) }
  let(:course_module_path) { "/#{course_year.core_induction_programme.to_param}/#{course_year.to_param}/#{course_module.to_param}" }
  let(:second_course_module) { FactoryBot.create(:course_module, title: "Second module title", previous_module: course_module) }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /create-module" do
      it "renders the create-module page" do
        get "/#{core_induction_programme.to_param}/create-module"
        expect(response).to render_template(:new)
      end
    end

    describe "POST /create-module" do
      it "creates a new module and redirects" do
        course_module.next_module = second_course_module
        create_course_module(course_module[:id])
        expect(response.location).to match("/spring-\\d+$")
      end

      it "creates a new module that is then displayed in the list of course module" do
        course_module.next_module = second_course_module
        create_course_module(course_module[:id])
        get "/#{core_induction_programme.to_param}/#{course_module.course_year.to_param}"
        expect(response.body).to include("Additional module title")
        expect(response.body).to include("Additional module content")
      end

      it "assigns a module to the previous module record" do
        course_module.next_module = second_course_module
        create_course_module(course_module[:id])

        third_course_module = CourseModule.find_by(title: "Additional module title")
        second_course_module.reload

        expect(third_course_module[:previous_module_id]).to eq(course_module[:id])
        expect(second_course_module[:previous_module_id]).to eq(third_course_module[:id])
      end

      it "assigns assigns a new module to the end of the module list" do
        create_course_module(second_course_module[:id])
        third_course_module = CourseModule.find_by(title: "Additional module title")
        expect(third_course_module[:previous_module_id]).to eq(second_course_module[:id])
      end
    end

    describe "GET /modules/:id" do
      it "renders the cip module page" do
        get course_module_path
        expect(response).to render_template(:show)
      end
    end

    describe "GET /modules/:id/edit" do
      it "renders the cip module edit page" do
        get "#{course_module_path}/edit"
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT /modules/:id" do
      it "renders a preview of changes to module" do
        put course_module_path, params: { commit: "See preview", course_module: { ect_summary: "Extra content" } }
        expect(response).to render_template(:edit)
        expect(response.body).to include("Extra content")
        course_module.reload
        expect(course_module.ect_summary).not_to include("Extra content")
      end

      it "redirects to the module page when saving content" do
        put course_module_path, params: { commit: "Save changes", course_module: { ect_summary: "Adding new content" } }
        expect(response).to redirect_to(course_module_path)
        get course_module_path
        expect(course_module.reload.ect_summary).to include("Adding new content")
      end

      it "redirects to the module page when saving title" do
        put course_module_path, params: { commit: "Save changes", course_module: { title: "New title", previous_module_id: "" } }
        expect(response).to redirect_to(course_module_path)
        get course_module_path
        expect(response.body).to include("Spring new title")
      end

      it "reassigns an existing modules previous module id when moved" do
        third_course_module = FactoryBot.create(:course_module, title: "third module title", previous_module: second_course_module)
        put course_module_path, params: { commit: "Save changes", course_module: { previous_module_id: third_course_module[:id] } }
        course_module.reload
        expect(course_module[:previous_module_id]).to eql(third_course_module[:id])
      end

      it "assigns nil to an existing module when a module is moved from first in the list" do
        third_course_module = FactoryBot.create(:course_module, title: "third module title", previous_module: second_course_module)

        put "/#{core_induction_programme.to_param}/#{course_module.course_year.to_param}/#{course_module.to_param}", params: {
          commit: "Save changes",
          course_module: {
            previous_module_id: third_course_module.id,
            course_year_id: course_module.course_year.id,
          },
        }
        course_module.reload
        second_course_module.reload
        expect(second_course_module[:previous_module_id]).to eq(nil)
        expect(course_module[:previous_module_id]).to eq(third_course_module[:id])
      end
    end
  end

  describe "when an ect is logged in" do
    before do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = core_induction_programme
      sign_in user
    end

    describe "GET /modules/:id" do
      it "renders the cip module page" do
        get course_module_path
        expect(response).to render_template(:show)
      end
    end

    describe "GET /modules/:id/edit" do
      it "raises an authorization error" do
        expect { get "#{course_module_path}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /create-module" do
      it "raises an authorization error" do
        expect { get "/#{core_induction_programme.to_param}/create-module" }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "POST /create-module" do
      it "raises an authorization error" do
        expect { create_course_module(course_module[:id]) }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a non-user is accessing the module page" do
    describe "GET /modules/:id/" do
      it "redirects to the sign in page" do
        get course_module_path
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /modules/:id/edit" do
      it "redirects to the sign in page" do
        get "#{course_module_path}/edit"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "PUT /modules/:id" do
      it "redirects to the sign in page" do
        put course_module_path, params: { commit: "Save changes", course_module: { ect_summary: course_module.ect_summary } }
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /create-module" do
      it "redirects to the sign in page" do
        get "/#{core_induction_programme.to_param}/create-module"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "POST /create-module" do
      it "redirects to the sign in page" do
        create_course_module(course_module[:id])
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end

def create_course_module(course_module_id)
  post "/#{core_induction_programme.to_param}/create-module",
       params: { course_module: {
         course_year_id: course_module.course_year[:id],
         title: "Additional module title",
         ect_summary: "Additional module content",
         term: "spring",
         previous_module_id: course_module_id,
       } }
end
