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

        it "redirects to the external users home path" do
          get "/users/sign-up"

          expect(response).to redirect_to "/home"
        end
      end
    end
  end

  describe "POST /users/sign-up" do
    let(:email) { Faker::Internet.email }

    context "the email is valid and not already used" do
      it "renders a success page and sends an invite email" do
        expect(UserMailer).to receive(:external_user_welcome_email).and_call_original
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:email_sent)
      end
    end

    context "the email is already used by another non-external user" do
      before do
        create(:user, :early_career_teacher, email: email)
      end

      it "renders a message telling the user it is in use and sends a sign in email" do
        expect(UserMailer).to receive(:sign_in_email).and_call_original
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:email_already_exists)
      end
    end

    context "an unverified account already exists" do
      before do
        user = create(:user, email: email)
        create(:external_user_profile, user: user)
      end

      it "it resends the link" do
        expect(UserMailer).to receive(:external_user_welcome_email).and_call_original
        post "/users/sign-up", params: { user: { email: email } }
        expect(response).to render_template(:email_sent)
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

  describe "POST /users/confirm-email" do
    let(:email) { Faker::Internet.email }
    let(:user) { create(:user, email: email) }

    context "the user exists and has an unexpired token" do
      let!(:external_user_profile) do
        create(
          :external_user_profile,
          :sent_verification_link,
          user: user,
        )
      end

      it "sets the user as verified, signs them in and renders the email-confirmed page" do
        get "/users/confirm-email", params: { token: external_user_profile.verification_token }
        expect(response).to render_template(:email_confirmed)
        expect(external_user_profile.reload).to be_verified
      end
    end

    xcontext "the user has an expired token" do
    end
  end
end
