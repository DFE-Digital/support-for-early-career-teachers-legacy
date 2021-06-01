# frozen_string_literal: true

require "rails_helper"

RSpec.describe Devise::Strategies::YoloAuthenticatable do
  let(:env) do
    Rack::MockRequest.env_for("", params: { user: { email: "user@example.com" } })
  end

  subject { described_class.new(env) }

  describe "#valid?" do
    it "returns true" do
      expect(subject.valid?).to be_truthy
    end
  end
end
