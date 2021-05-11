# frozen_string_literal: true

require "rails_helper"

RSpec.describe "core_induction_programmes/modules/show.html.erb" do
  before do
    controller.singleton_class.class_eval do
      def current_user
        @current_user ||= User.last
      end
      helper_method :current_user
    end
  end

  let(:course_module) { create(:course_module, :with_lessons) }
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context "when an admin" do
    context "course module without lesson parts" do
      it "can click thru to lesson" do
        assign(:course_module, course_module)
        assign(:course_lessons_with_progress, course_module.lessons_with_progress(admin))

        enable_pundit(view, admin)

        render
        document = Nokogiri::HTML(rendered)
        expect(document.css("a[href='/lessons/#{course_module.course_lessons.sample.id}']")).to be_present
      end
    end

    context "course module with lesson parts" do
      let(:course_module) { create(:course_module, :with_lessons, with_lessons_traits: [:with_lesson_part]) }

      it "can click thru to lesson" do
        assign(:course_module, course_module)
        assign(:course_lessons_with_progress, course_module.lessons_with_progress(admin))

        enable_pundit(view, admin)

        render
        document = Nokogiri::HTML(rendered)
        expect(document.css("a[href='/lessons/#{course_module.course_lessons.sample.id}']")).to be_present
      end
    end
  end

  context "when not an admin" do
    context "course module without lesson parts" do
      it "cannot click thru to lesson" do
        assign(:course_module, course_module)
        assign(:course_lessons_with_progress, course_module.lessons_with_progress(user))

        enable_pundit(view, user)

        render
        document = Nokogiri::HTML(rendered)
        expect(document.css("a[href='/lessons/#{course_module.course_lessons.sample.id}']")).not_to be_present
      end
    end

    context "course module with lesson parts" do
      let(:course_module) { create(:course_module, :with_lessons, with_lessons_traits: [:with_lesson_part]) }

      it "can click thru to lesson" do
        assign(:course_module, course_module)
        assign(:course_lessons_with_progress, course_module.lessons_with_progress(user))

        enable_pundit(view, user)

        render
        document = Nokogiri::HTML(rendered)
        expect(document.css("a[href='/lessons/#{course_module.course_lessons.sample.id}']")).to be_present
      end
    end
  end
end
