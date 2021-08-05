# frozen_string_literal: true

require "rails_helper"

RSpec.describe GuidanceSpeedbumpForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:view_guidance_option).with_message("Select if you would like a brief summary of the programme") }
  end
end
