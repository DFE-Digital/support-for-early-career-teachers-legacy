# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorMaterialPart, type: :model do
  it "can be created" do
    expect {
      MentorMaterialPart.create(
        title: "Test mentor materials",
        content: "No content",
        mentor_material: FactoryBot.create(:mentor_material),
      )
    }.to change { MentorMaterialPart.count }.by(1)
  end

  it "can be deleted" do
    mentor_material_part = FactoryBot.create(:mentor_material_part)
    expect { mentor_material_part.destroy }.to change { MentorMaterialPart.count }.by(-1)
  end

  describe "associations" do
    it { is_expected.to belong_to(:mentor_material) }
    it { is_expected.to have_one(:next_mentor_material_part).dependent(:nullify) }
    it { is_expected.to belong_to(:previous_mentor_material_part).optional }
  end

  describe "validations" do
    subject { FactoryBot.create(:course_lesson_part) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_presence_of(:content).with_message("Enter content") }
    it { is_expected.to validate_length_of(:content).is_at_most(100_000) }
  end
end
