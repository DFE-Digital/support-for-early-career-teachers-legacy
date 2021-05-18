# frozen_string_literal: true

require "rails_helper"

RSpec.describe MentorProfile, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:core_induction_programme).optional }
    it { is_expected.to belong_to(:cohort).optional }
  end
end
