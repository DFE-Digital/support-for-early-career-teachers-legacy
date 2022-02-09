# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign-up" do
    it "renders the sign in page" do
      get "/users/sign-up"

      expect(response).to render_template(:new)
    end

    context "when already signed in" do
      before { sign_in user }

      context "user is not an external user" do
        it "redirects to the dashboard" do
          get "/users/sign-up"

          expect(response).to redirect_to "/dashboard"
        end
      end

      context "user is an external user" do
        let(:user) { create(:user, :external_user) }

        it "redirects to the cip index path" do
          get "/users/sign-up"

          expect(response).to redirect_to "/providers"
        end
      end
    end
  end

  describe "POST /users/sign-up" do
    let(:email) { Faker::Internet.email }

    context "the email is valid and not already used" do
      it "renders a success page and sends an invite email" do
        expect(UserMailer).to receive(:external_user_welcome_email)
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:email_sent)
      end
    end

    context "the email is already used by another user" do
      before do
        create(:user, email: email)
      end

      it "renders a message telling the user it is in use and sends a sign in email" do
        expect(UserMailer).to receive(:sign_in_email).and_call_original
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:email_already_exists)
      end
    end

    context "the email field is left blank" do
      it "tells the user to enter an email" do
        post "/users/sign-up", params: { user: {} }
        expect(response).to render_template(:new)
        expect(response.body).to include("Enter an email")
      end
    end

    context "the email is invalid" do
      let(:email) { "moose" }

      it "tells the user to enter a valid email" do
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:new)
        expect(response.body).to include("Enter a valid email address")
      end
    end
  end
end
