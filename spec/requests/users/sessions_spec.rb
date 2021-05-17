# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  let(:user) { create(:user, account_created: true) }

  describe "GET /users/sign_in" do
    it "renders the sign in page" do
      get "/users/sign_in"

      expect(response).to render_template(:new)
    end

    context "when already signed in" do
      before { sign_in user }

      it "redirects to the dashboard" do
        get "/users/sign_in"

        expect(response).to redirect_to "/dashboard"
      end
    end
  end

  describe "POST /users/sign_in" do
    context "when email matches a user" do
      it "redirects to dashboard" do
        post "/users/sign_in", params: { user: { email: user.email } }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when email doesn't match any user" do
      context "user does not exist on api" do
        let(:email) { Faker::Internet.email }

        it "renders the login_email_sent template to prevent exposing information about user accounts" do
          post "/users/sign_in", params: { user: { email: email } }
          expect(response).to render_template(:new)
        end
      end

      context "user does exist in api" do
        let(:email) { "induction-tutor@example.com" }

        it "redirects to dashboard" do
          post "/users/sign_in", params: { user: { email: user.email } }
          expect(response).to redirect_to(dashboard_path)
        end
      end
    end
  end
end
