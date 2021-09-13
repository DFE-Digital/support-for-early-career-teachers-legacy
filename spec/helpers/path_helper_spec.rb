# frozen_string_literal: true

require "rails_helper"

RSpec.describe PathHelper, type: :helper do
  let(:course_year) { FactoryBot.create(:course_year, mentor_title: "Mentor title") }
  let!(:core_induction_programme) { course_year.core_induction_programme }
  let(:course_module) { create(:course_module, course_year: course_year) }
  let(:course_lesson) { create(:course_lesson, :with_lesson_part, course_module: course_module) }
  let(:course_lesson_part) { course_lesson.course_lesson_parts[0] }
  let(:mentor_material) { create(:mentor_material, :with_mentor_material_part, course_lesson: course_lesson) }
  let(:mentor_material_part) { mentor_material.mentor_material_parts[0] }

  let(:expected_cip_path) { "/#{core_induction_programme.to_param}" }
  let(:expected_year_path) { "#{expected_cip_path}/#{course_year.to_param}" }
  let(:expected_module_path) { "#{expected_year_path}/#{course_module.to_param}" }
  let(:expected_lesson_path) { "#{expected_module_path}/#{course_lesson.to_param}" }
  let(:expected_lesson_part_path) { "#{expected_lesson_path}/#{course_lesson_part.to_param}" }
  let(:expected_mentor_material_path) { "#{expected_lesson_path}/mentoring/#{mentor_material.to_param}" }
  let(:expected_mentor_material_part_path) { "#{expected_mentor_material_path}/#{mentor_material_part.to_param}" }

  describe "#edit_year_path" do
    it "returns correct path" do
      expect(edit_year_path(course_year)).to eq("#{expected_year_path}/edit")
    end
  end

  describe "#module_path" do
    it "returns correct path" do
      expect(module_path(course_module)).to eq(expected_module_path)
    end
  end

  describe "#edit_module_path" do
    it "returns correct path" do
      expect(edit_module_path(course_module)).to eq("#{expected_module_path}/edit")
    end
  end

  describe "#lesson_path" do
    it "returns correct path" do
      expect(lesson_path(course_lesson)).to eq(expected_lesson_path)
    end
  end

  describe "#edit_lesson_path" do
    it "returns correct path" do
      expect(edit_lesson_path(course_lesson)).to eq("#{expected_lesson_path}/edit")
    end
  end

  describe "#lesson_part_path" do
    it "returns correct path" do
      expect(lesson_part_path(course_lesson_part)).to eq(expected_lesson_part_path)
    end
  end

  describe "#edit_lesson_part_path" do
    it "returns correct path" do
      expect(edit_lesson_part_path(course_lesson_part)).to eq("#{expected_lesson_part_path}/edit")
    end
  end

  describe "#lesson_part_split_path" do
    it "returns correct path" do
      expect(lesson_part_split_path(course_lesson_part)).to eq("#{expected_lesson_part_path}/split")
    end
  end

  describe "#lesson_part_show_delete_path" do
    it "returns correct path" do
      expect(lesson_part_show_delete_path(course_lesson_part)).to eq("#{expected_lesson_part_path}/delete")
    end
  end

  describe "#lesson_part_update_progress_path" do
    it "returns correct path" do
      expect(lesson_part_update_progress_path(course_lesson_part)).to eq("#{expected_lesson_part_path}/update-progress")
    end
  end

  describe "#mentor_material_path" do
    it "returns correct path" do
      expect(mentor_material_path(mentor_material)).to eq(expected_mentor_material_path)
    end
  end

  describe "#edit_mentor_material_path" do
    it "returns correct path" do
      expect(edit_mentor_material_path(mentor_material)).to eq("#{expected_mentor_material_path}/edit")
    end
  end

  describe "#mentor_material_part_path" do
    it "returns correct path" do
      expect(mentor_material_part_path(mentor_material_part)).to eq(expected_mentor_material_part_path)
    end
  end

  describe "#edit_mentor_material_part_path" do
    it "returns correct path" do
      expect(edit_mentor_material_part_path(mentor_material_part)).to eq("#{expected_mentor_material_part_path}/edit")
    end
  end

  describe "#mentor_material_part_split_path" do
    it "returns correct path" do
      expect(mentor_material_part_split_path(mentor_material_part)).to eq("#{expected_mentor_material_part_path}/split")
    end
  end

  describe "#mentor_material_part_show_delete_path" do
    it "returns correct path" do
      expect(mentor_material_part_show_delete_path(mentor_material_part)).to eq("#{expected_mentor_material_part_path}/delete")
    end
  end
end
