# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorMaterial, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:course_lesson) }
    it { is_expected.to have_one(:course_module) }
    it { is_expected.to have_one(:course_year) }
    it { is_expected.to delegate_method(:core_induction_programme).to(:course_year) }
  end

  describe "validations" do
    subject { FactoryBot.create(:mentor_material) }
    it { is_expected.to validate_presence_of(:title).with_message("Enter a title") }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
  end
end
