# frozen_string_literal: true

require "rails_helper"

describe CipBreadcrumbHelper do
  describe "core-induction-programme" do
    let(:user) { create(:user, :admin) }
    let(:course_year) { create(:course_year) }
    let(:course_module) { create(:course_module, course_year: course_year) }
    let(:course_lesson) { create(:course_lesson, course_module: course_module) }

    it "returns an array for the course year breadcrumb" do
      course_year_breadcrumb = helper.course_year_breadcrumbs(user, course_year)

      course_year_crumb = [["Home", "/dashboard"], [course_year.title, "/core-induction-programme/years/#{course_year.id}"]]

      expect(course_year_breadcrumb).to eq(course_year_crumb)
    end

    it "returns an array for the course module breadcrumb" do
      course_module_breadcrumb = helper.course_module_breadcrumbs(user, course_module)

      course_year_crumb = [course_year.title, "/core-induction-programme/years/#{course_year.id}"]
      course_module_crumb = [course_module.title, "/core-induction-programme/years/#{course_year.id}/modules/#{course_module.id}"]

      expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], course_year_crumb, course_module_crumb])
    end

    it "returns an array for the course lesson breadcrumb" do
      course_lesson_breadcrumb = helper.course_lesson_breadcrumbs(user, course_lesson)

      course_year_crumb = [course_year.title, "/core-induction-programme/years/#{course_year.id}"]
      course_module_crumb = [course_module.title, "/core-induction-programme/years/#{course_year.id}/modules/#{course_module.id}"]
      course_lesson_crumb = [course_lesson.title, "/core-induction-programme/years/#{course_year.id}/modules/#{course_module.id}/lessons/#{course_lesson.id}"]

      expect(course_lesson_breadcrumb).to eq([["Home", "/dashboard"], course_year_crumb, course_module_crumb, course_lesson_crumb])
    end

    it "returns a string for the end crumb when rendered the action_name is show" do
      allow(helper).to receive(:action_name) { "show" }

      course_year_breadcrumb = helper.course_year_breadcrumbs(user, course_year)
      course_year_crumb = [["Home", "/dashboard"], "Test Course year"]

      expect(course_year_breadcrumb).to eql(course_year_crumb)
    end

    it "returns the title and url for the end crumb when the action_name is edit" do
      allow(helper).to receive(:action_name) { "edit" }

      course_year_breadcrumb = helper.course_year_breadcrumbs(user, course_year)
      course_year_crumb = [["Home", "/dashboard"], [course_year.title, "/core-induction-programme/years/#{course_year.id}"]]

      expect(course_year_breadcrumb).to eql(course_year_crumb)
    end
  end
end
