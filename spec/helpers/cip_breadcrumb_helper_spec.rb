# frozen_string_literal: true

require "rails_helper"

describe CipBreadcrumbHelper, type: :helper do
  before :each do
    @user = FactoryBot.create(:user, :admin)
    @course_year = FactoryBot.create(:course_year)
    @year_crumb = ["Your module materials", "/years/#{@course_year.id}"]
  end

  describe "#course_year_breadcrumbs" do
    let(:year_breadcrumbs) { helper.course_year_breadcrumbs(@user, @course_year) }
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

  describe "#course_module_breadcrumbs" do
    let(:course_module) { create(:course_module, course_year: @course_year) }
    let(:course_module_crumb) { [course_module.title, "/modules/#{course_module.id}"] }
    let(:course_module_breadcrumb) { helper.course_module_breadcrumbs(@user, course_module) }

    it "returns an array for the course module breadcrumb" do
      expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
    end

    it "returns a url for the end crumb when the action_name is edit" do
      allow(helper).to receive(:action_name) { "edit" }
      expect(course_module_breadcrumb).to eq([["Home", "/dashboard"], @year_crumb, course_module_crumb])
    end

    it "returns just the title for the end crumb when the action_name is show" do
      allow(helper).to receive(:action_name) { "show" }
      expect(course_module_breadcrumb).to eql([["Home", "/dashboard"], @year_crumb, course_module.title])
    end
  end

  describe "#lesson_breadcrumbs" do
    let(:course_module) { create(:course_module, course_year: @course_year) }
    let(:course_lesson) { create(:course_lesson, course_module: course_module) }
    let(:course_module_crumb) { [course_module.title, "/modules/#{course_module.id}"] }
    let(:course_lesson_crumb) { [course_lesson.title, "/lessons/#{course_lesson.id}"] }
    let(:course_lesson_breadcrumb) { helper.course_lesson_breadcrumbs(@user, course_lesson) }

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
end
