# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mentor materials", type: :request do
  let(:mentor_material) { create(:mentor_material) }

  describe "index" do
    it "renders index temlate" do
      get "/mentor-materials"
      expect(response).to render_template(:index)
    end
  end

  describe "show" do
    it "renders the core_induction_programme show page" do
      get "/mentor-materials#{mentor_material.id}"
      expect(response).to render_template(:show)
    end
  end
end
