# frozen_string_literal: true

require "rails_helper"

describe CipBreadcrumbHelper, type: :helper do
  let(:early_career_teacher) { FactoryBot.build(:user, :early_career_teacher) }
  let(:mentor) { FactoryBot.build(:user, :mentor) }
  let(:admin) { FactoryBot.build(:user, :admin) }
  let(:course_year) { FactoryBot.create(:course_year, mentor_title: "Mentor title") }

  before do
    @year_crumb = [course_year.title, "/years/#{course_year.id}"]
    @mentor_year_crumb = [course_year.mentor_title, "/years/#{course_year.id}"]
  end

  describe "#course_year_breadcrumbs" do
    context "early career teacher" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(early_career_teacher, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], @year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], @year_crumb[0]])
      end
    end

    context "mentor" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(mentor, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], @mentor_year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], @mentor_year_crumb[0]])
      end
    end

    context "admin" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(admin, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], @year_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], @year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], @year_crumb[0]])
      end
    end
  end

  describe "#course_module_breadcrumbs" do
    let(:course_module) { create(:course_module, course_year: course_year) }
    let(:course_module_crumb) { [course_module.term_and_title, "/modules/#{course_module.id}"] }

    context "early career teacher" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(early_career_teacher, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], @year_crumb, course_module.term_and_title])
      end
    end

    context "mentor" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(mentor, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @mentor_year_crumb, course_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], @mentor_year_crumb, course_module.term_and_title])
      end
    end

    context "admin" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(admin, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], @year_crumb, course_module.term_and_title])
      end
    end
  end

  describe "#course_lesson_breadcrumbs" do
    let(:course_module) { create(:course_module, course_year: course_year) }
    let(:course_lesson) { create(:course_lesson, course_module: course_module) }
    let(:course_module_crumb) { [course_module.term_and_title, "/modules/#{course_module.id}"] }
    let(:course_lesson_crumb) { [course_lesson.title, "/lessons/#{course_lesson.id}"] }

    context "early career teacher" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(early_career_teacher, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb, course_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb, course_lesson.title])
      end
    end

    context "mentor" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(mentor, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @mentor_year_crumb, course_module_crumb, course_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eql([["Home", "/dashboard"], @mentor_year_crumb, course_module_crumb, course_lesson.title])
      end
    end

    context "admin" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(admin, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb, course_lesson_crumb])
      end

      it "returns the url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb, course_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb, course_lesson.title])
      end
    end

    context "creating a course_lesson and module is not yet known" do
      let(:course_lesson) { CourseLesson.new }

      it "returns Home => /dashboard, Create lesson" do
        expect(helper.course_lesson_breadcrumbs(early_career_teacher, course_lesson)).to eql([["Home", "/dashboard"], ["Create lesson"]])
      end
    end
  end
end
