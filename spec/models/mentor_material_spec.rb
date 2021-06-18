# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorMaterial, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:course_lesson).optional }
    it { is_expected.to belong_to(:course_module).optional }
    it { is_expected.to belong_to(:course_year).optional }
    it { is_expected.to belong_to(:core_induction_programme).optional }
  end

  describe "validations" do
    subject { FactoryBot.create(:mentor_material) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
  end
end
