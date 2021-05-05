# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PreferredNames", type: :request do
  let(:user) { create(:user, account_created: false) }

  before do
    sign_in user
  end

  describe "GET /preferred-name/edit" do
    it "renders edit template" do
      get "/preferred-name/edit"
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT /preferred-name" do
    it "redirects successfully" do
      put "/preferred-name", params: { user: { preferred_name: "Test" } }
      expect(response).to redirect_to(dashboard_path)
    end

    it "sets preferred-name and account_created" do
      put "/preferred-name", params: { user: { preferred_name: "Test" } }
      expect(user.name).to eq("Test")
    end
  end
end
