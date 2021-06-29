# frozen_string_literal: true

require "rails_helper"

describe CipBreadcrumbHelper, type: :helper do
  let(:early_career_teacher) { FactoryBot.build(:user, :early_career_teacher) }
  let(:mentor) { FactoryBot.build(:user, :mentor) }
  let(:admin) { FactoryBot.build(:user, :admin) }
  let(:course_year) { FactoryBot.create(:course_year, :with_cip, mentor_title: "Mentor title") }
  let(:core_induction_programme) { course_year.core_induction_programme }
  let(:course_module) { create(:course_module, course_year: course_year) }
  let(:course_lesson) { create(:course_lesson, course_module: course_module) }

  let(:cip_path) { "/#{core_induction_programme.to_param}" }
  let(:year_path) { "#{cip_path}/#{course_year.to_param}" }
  let(:module_path) { "#{year_path}/#{course_module.to_param}" }
  let(:lesson_path) { "#{module_path}/#{course_lesson.to_param}" }

  let(:expected_year_crumb) { [course_year.title, year_path] }
  let(:expected_mentor_year_crumb) { [course_year.mentor_title, year_path] }
  let(:expected_module_crumb) { [course_module.term_and_title, module_path] }
  let(:expected_lesson_crumb) { [course_lesson.title, lesson_path] }

  describe "#course_year_breadcrumbs" do
    context "early career teacher" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(early_career_teacher, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], expected_year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], expected_year_crumb[0]])
      end
    end

    context "mentor" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(mentor, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], expected_mentor_year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], expected_mentor_year_crumb[0]])
      end
    end

    context "admin" do
      let(:year_breadcrumbs) { helper.course_year_breadcrumbs(admin, course_year) }

      it "returns an array for the course year breadcrumb" do
        expect(year_breadcrumbs).to eq([["Home", "/dashboard"], expected_year_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], expected_year_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(year_breadcrumbs).to eql([["Home", "/dashboard"], expected_year_crumb[0]])
      end
    end
  end

  describe "#course_module_breadcrumbs" do
    context "early career teacher" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(early_career_teacher, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], expected_year_crumb, course_module.term_and_title])
      end
    end

    context "mentor" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(mentor, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], expected_mentor_year_crumb, expected_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], expected_mentor_year_crumb, course_module.term_and_title])
      end
    end

    context "admin" do
      let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(admin, course_module) }

      it "returns an array for the course module breadcrumb" do
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb])
      end

      it "returns a url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], expected_year_crumb, course_module.term_and_title])
      end
    end
  end

  describe "#course_lesson_breadcrumbs" do
    context "early career teacher" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(early_career_teacher, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb, expected_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb, course_lesson.title])
      end
    end

    context "mentor" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(mentor, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_mentor_year_crumb, expected_module_crumb, expected_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eql([["Home", "/dashboard"], expected_mentor_year_crumb, expected_module_crumb, course_lesson.title])
      end
    end

    context "admin" do
      let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(admin, course_lesson) }

      it "returns an array for the course lesson breadcrumb" do
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb, expected_lesson_crumb])
      end

      it "returns the url for the end crumb when the action_name is edit" do
        allow(helper).to receive(:action_name) { "edit" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb, expected_lesson_crumb])
      end

      it "returns just the title for the end crumb when the action_name is show" do
        allow(helper).to receive(:action_name) { "show" }
        expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], expected_year_crumb, expected_module_crumb, course_lesson.title])
      end
    end
  end
end
