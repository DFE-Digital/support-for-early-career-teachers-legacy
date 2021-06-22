# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MentorMaterialsParts", type: :request do
  let(:cip) { create(:core_induction_programme, course_year_one: course_year) }
  let(:mentor_material_part) { create(:mentor_material_part) }
  let(:mentor_material) { mentor_material_part.mentor_material }
  let(:course_lesson) { mentor_material.course_lesson }
  let(:course_module) { course_lesson.course_module }
  let(:course_year) { course_module.course_year }

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

    describe "DELETE /mentor-material-parts/:id" do
      it "deletes a mentor material part and redirects to a mentor material" do
        post "/mentor-material-parts/#{mentor_material_part.id}/split", params: {
          commit: "Save changes",
          split_mentor_material_part_form: {
            title: "Updated title one",
            content: "Updated content",
            new_title: "Title two",
            new_content: "Content two",
          },
        }
        delete "/mentor-material-parts/#{mentor_material_part.id}", params: { id: mentor_material.mentor_material_parts[1].id }

        expect(MentorMaterialPart.count).to eq(1)
        expect(response).to redirect_to("/mentor-materials/#{mentor_material.id}")
      end

      it "raises an authorization error when there is 1 mentor material part" do
        expect { delete "/mentor-material-parts/#{mentor_material_part.id}", params: { id: mentor_material.mentor_material_parts[0].id } }.to raise_error Pundit::NotAuthorizedError
      end
    end

    describe "GET /mentor-material-parts/:id/split" do
      it "renders the mentor material part split page" do
        get "/mentor-material-parts/#{mentor_material_part.id}/split"
        expect(response).to render_template(:show_split)
      end
    end

    describe "POST /mentor-material-parts/:id/split" do
      it "renders a preview of changes to mentor material part" do
        post "/mentor-material-parts/#{mentor_material_part.id}/split", params: {
          commit: "See preview",
          split_mentor_material_part_form: {
            title: "Updated title one",
            content: "Updated content",
            new_title: "Title two",
            new_content: "Content two",
          },
        }
        expect(response).to render_template(:show_split)
        expect(response.body).to include("Updated title one")
        expect(response.body).to include("Updated content")
        expect(response.body).to include("Title two")
        expect(response.body).to include("Content two")

        expect(MentorMaterialPart.count).to eq(1)
        mentor_material_part.reload
        expect(mentor_material_part.content).not_to include("Extra content")
      end

      it "splits the mentor material part and redirects to show" do
        post "/mentor-material-parts/#{mentor_material_part.id}/split", params: {
          commit: "Save changes",
          split_mentor_material_part_form: {
            title: "Updated title one",
            content: "Updated content",
            new_title: "Title two",
            new_content: "Content two",
          },
        }
        expect(response).to redirect_to("/mentor-material-parts/#{mentor_material_part.id}")

        expect(MentorMaterialPart.count).to eq(2)
        mentor_material_part.reload
        expect(mentor_material_part.title).to eq "Updated title one"
        expect(mentor_material_part.content).to eq "Updated content"
        expect(mentor_material_part.next_mentor_material_part.title).to eq "Title two"
        expect(mentor_material_part.next_mentor_material_part.content).to eq "Content two"

        post "/mentor-material-parts/#{mentor_material_part.id}/split", params: {
          commit: "Save changes",
          split_mentor_material_part_form: {
            title: "Updated title one again",
            content: "Updated content again",
            new_title: "Title one point five",
            new_content: "Content one point five",
          },
        }

        expect(MentorMaterialPart.count).to eq(3)
        mentor_material_part.reload
        expect(mentor_material_part.title).to eq "Updated title one again"
        expect(mentor_material_part.content).to eq "Updated content again"
        expect(mentor_material_part.next_mentor_material_part.title).to eq "Title one point five"
        expect(mentor_material_part.next_mentor_material_part.content).to eq "Content one point five"
        expect(mentor_material_part.next_mentor_material_part.next_mentor_material_part.title).to eq "Title two"
        expect(mentor_material_part.next_mentor_material_part.next_mentor_material_part.content).to eq "Content two"
      end
    end

    describe "GET /mentor-material-parts/:id/show_delete" do
      it "renders the mentor material part show_delete page when there is > 1 mentor material part" do
        FactoryBot.create(:mentor_material_part, mentor_material: mentor_material)
        get "/mentor-material-parts/#{mentor_material_part.id}/show_delete"
        expect(response).to render_template(:show_delete)
      end

      it "raises an authorization error when there is 1 mentor material part" do
        expect { get "/mentor-material-parts/#{mentor_material_part.id}/show_delete" }.to raise_error Pundit::NotAuthorizedError
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
