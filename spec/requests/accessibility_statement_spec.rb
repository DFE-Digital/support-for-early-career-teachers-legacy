# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accessibility statement", type: :request do
  describe "GET /accessibility-statement" do
    it "should show the Accessibility statement" do
      get accessibility_statement_path

      expect(response).to render_template :show
      expect(response.body).to include("Accessibility statement for Support for early career teachers service")
    end
  end
end
