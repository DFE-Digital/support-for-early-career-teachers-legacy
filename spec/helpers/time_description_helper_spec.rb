# frozen_string_literal: true

require "rails_helper"

describe TimeDescriptionHelper, type: :helper do
  describe ".minutes_to_words" do
    it "returns an integer < 60 converted to words showing just minutes" do
      expect(helper.minutes_to_words(55)).to eql("55 minutes")
    end

    it "returns an integer > 59 & < 120 converted to words showing the singular of hour and minute" do
      expect(helper.minutes_to_words(61)).to eql("1 hour 1 minute")
    end

    it "returns hours and minutes pluralized" do
      expect(helper.minutes_to_words(122)).to eql("2 hours 2 minutes")
    end

    it "returns only the hour when there is 0 minutes" do
      expect(helper.minutes_to_words(60)).to eql("1 hour")
    end

    it "returns hours pluralized and only the hours when there is 0 minutes" do
      expect(helper.minutes_to_words(120)).to eql("2 hours")
    end
  end
end
