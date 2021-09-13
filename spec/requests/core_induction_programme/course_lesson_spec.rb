# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Core Induction Programme Lesson", type: :request do
  let(:cip) { create(:core_induction_programme) }
  let(:course_year) { FactoryBot.create(:course_year, core_induction_programme: cip) }
  let(:course_module) { FactoryBot.create(:course_module, course_year: course_year) }
  let(:course_lesson) { FactoryBot.create(:course_lesson, course_module: course_module) }
  let(:course_lesson_path) { "/#{cip.to_param}/#{course_year.to_param}/#{course_module.to_param}/#{course_lesson.to_param}" }

  describe "when an admin user is logged in" do
    before do
      admin_user = create(:user, :admin)
      sign_in admin_user
    end

    describe "GET /lessons/:id" do
      it "renders the cip lesson page if lesson has no parts" do
        get course_lesson_path
        expect(response).to render_template(:show)
      end

      it "redirects to lesson part page of the first part if lesson has no some parts" do
        part_one = CourseLessonPart.create!(course_lesson: course_lesson, content: "Content One", title: "Title One")
        CourseLessonPart.create!(course_lesson: course_lesson, content: "Content Two", title: "Title Two")
        get course_lesson_path
        expect(response).to redirect_to("#{course_lesson_path}/#{part_one.to_param}")
      end

      it "does not track progress" do
        get course_lesson_path
        expect(CourseLessonProgress.count).to eq(0)
      end

      it "renders the cip edit lesson page" do
        get "#{course_lesson_path}/edit"
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT /lessons/:id" do
      it "redirects to the lesson page when saving title" do
        put course_lesson_path, params: { course_lesson: { commit: "Save changes", title: "New title" } }
        expect(response).to redirect_to(course_lesson_path)
        get course_lesson_path
        expect(response.body).to include("New title")
      end

      it "redirects to the lesson page when saving minutes" do
        put course_lesson_path, params: { course_lesson: { commit: "Save changes", completion_time_in_minutes: 80 } }
        expect(response).to redirect_to(course_lesson_path)
        get course_lesson_path
        expect(response.body).to include("Duration: 1 hour 20 minutes")
      end

      it "renders the error page with an error when an invalid number is inputted" do
        put course_lesson_path, params: { course_lesson: { commit: "Save changes", completion_time_in_minutes: -10 } }
        expect(response).to render_template(:edit)
        expect(response.body).to include("Enter a number greater than 0")
      end

      it "allows a course lesson to be reassigned to a different course module" do
        second_course_module = FactoryBot.create(:course_module, course_year: course_year)
        put course_lesson_path, params: { course_lesson: { commit: "Save changes", course_module_id: second_course_module[:id] } }
        course_lesson.reload
        expect(course_lesson[:course_module_id]).to eq(second_course_module[:id])
      end

      context "when re-ordering" do
        it "allows lesson to be re-ordered" do
          first_course_lesson = FactoryBot.create(:course_lesson, course_module: course_module)
          second_course_lesson = FactoryBot.create(:course_lesson, course_module: course_module)
          third_course_lesson = course_lesson

          put course_lesson_path, params: { course_lesson: { new_position: "2" } }

          expect(course_module.reload.course_lessons).to eq([first_course_lesson, third_course_lesson, second_course_lesson])
        end
      end
    end

    describe "GET /create-lesson" do
      it "renders the new lesson page" do
        get cip_create_lesson_path(cip)
        expect(response).to render_template(:new)
      end
    end

    describe "POST /create-lesson" do
      it "creates a new lesson" do
        expect {
          post cip_create_lesson_path(cip), params: {
            course_lesson: {
              title: "new lesson title",
              ect_summary: "new ect summary",
              completion_time_in_minutes: "10",
              course_module_id: course_module.id,
            },
          }
        }.to change(CourseLesson, :count).by(1)
      end

      it "redirects to the lesson" do
        post cip_create_lesson_path(cip), params: {
          course_lesson: {
            title: "new lesson title",
            ect_summary: "new ect summary",
            completion_time_in_minutes: "10",
            course_module_id: course_module.id,
          },
        }

        new_lesson = CourseLesson.last
        expect(response).to redirect_to("/#{cip.to_param}/#{course_year.to_param}/#{course_module.to_param}/#{new_lesson.to_param}")
      end

      context "when invalid data provided" do
        it "renders new template" do
          post cip_create_lesson_path(cip), params: {
            course_lesson: {
              title: "",
              ect_summary: "new ect summary",
              completion_time_in_minutes: "10",
              course_module_id: course_module.id,
            },
          }

          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "when an ect is logged in" do
    let(:user) do
      user = create(:user, :early_career_teacher)
      user.early_career_teacher_profile.core_induction_programme = cip
      user
    end

    let(:progress) do
      CourseLessonProgress.find_by(
        course_lesson: course_lesson,
        early_career_teacher_profile: user.early_career_teacher_profile,
      ).progress
    end

    before do
      sign_in user
    end

    describe "GET /lessons/:id" do
      it "renders the cip lesson page" do
        get course_lesson_path
        expect(response).to render_template(:show)
      end

      it "leaves progress unchanged when lesson is completed" do
        CourseLessonProgress.create!(
          course_lesson: course_lesson,
          early_career_teacher_profile: user.early_career_teacher_profile,
          progress: "complete",
        )
        get course_lesson_path
        expect(progress).to eq("complete")
      end
    end

    describe "GET /lessons/:id/edit" do
      it "redirects to the sign in page" do
        expect { get "#{course_lesson_path}/edit" }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "when a non-user is accessing the lesson page" do
    describe "GET /lessons/:id" do
      it "redirects to the sign in page" do
        get course_lesson_path
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "GET /lessons/:id/edit" do
      it "redirects to the sign in page" do
        get "#{course_lesson_path}/edit"
        expect(response).to redirect_to("/users/sign_in")
      end
    end

    describe "PUT /lessons/:id" do
      it "redirects to the sign in page" do
        put course_lesson_path, params: { commit: "Save changes" }
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
