# frozen_string_literal: true

require "rails_helper"

RSpec.describe LessonNewPositionComponent, type: :component do
  let(:course_module) { lesson.course_module }
  subject { described_class.new(lesson: lesson, form: form) }

  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::FormOptionsHelper
    template
  end

  let(:form) { GOVUKDesignSystemFormBuilder::FormBuilder.new(:test, OpenStruct.new, template, {}) }

  context "when there are no other lessons" do
    let(:lesson) { create(:course_lesson) }

    it "has only one option" do
      result = render_inline(subject)
      expect(result.css("option").count).to eql(1)
    end

    it "marks only option as selected" do
      result = render_inline(subject)
      expect(result.css("option[selected]").count).to eql(1)
    end
  end

  context "when there are other lessons" do
    let(:lesson) { create(:course_lesson) }
    let(:last_lesson) { create(:course_lesson, course_module: course_module) }

    before do
      lesson
      last_lesson
    end

    subject { described_class.new(lesson: last_lesson, form: form) }

    it "includes other lessons as options" do
      result = render_inline(subject)
      expect(result.css("option").count).to eql(2)
    end

    it "marks prior lesson as selected" do
      result = render_inline(subject)
      expect(result.css("option[selected]").text).to eql(lesson.title)
    end
  end
end
