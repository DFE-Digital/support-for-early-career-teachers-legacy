# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  let(:user) { create(:user) }

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

  describe "POST /users/sign_in" do
    context "when an early career teacher is trying to log in" do
      let(:ect) { create(:user, :early_career_teacher) }

      context "when email matches an ect" do
        it "redirects to dashboard" do
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to redirect_to(dashboard_path)
          expect(ect.reload.last_sign_in_at).not_to be_nil
        end
      end

      context "when a user isn't registered but has accessed the service prior to public beta" do
        it "redirects to dashboard" do
          ect.early_career_teacher_profile.update!(registration_completed: false)
          InviteEmailEct.create!(user: ect, sent_at: Time.zone.now)
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to redirect_to(dashboard_path)
          expect(ect.reload.last_sign_in_at).not_to be_nil
        end
      end

      context "when a user isn't registered and has not accessed the service prior to public beta" do
        it "redirects to dashboard" do
          ect.early_career_teacher_profile.update!(registration_completed: false)
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to render_template(:new)
          expect(ect.reload.last_sign_in_at).to be_nil
        end
      end

      context "when a user's induction programme choice is a full induction programme" do
        it "renders sign_in page" do
          ect.early_career_teacher_profile.full_induction_programme!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to render_template(:new)
        end

        it "does not sign in the user" do
          ect.early_career_teacher_profile.full_induction_programme!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(ect.reload.last_sign_in_at).to be_nil
        end
      end

      context "when a user's induction programme choice has no early career teachers" do
        it "renders sign_in page" do
          ect.early_career_teacher_profile.no_early_career_teachers!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to render_template(:new)
        end

        it "does not sign in the user" do
          ect.early_career_teacher_profile.no_early_career_teachers!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(ect.reload.last_sign_in_at).to be_nil
        end
      end

      context "when a user is doing a designed induction programme" do
        it "renders sign_in page" do
          ect.early_career_teacher_profile.design_our_own!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to render_template(:new)
        end

        it "does not sign in the user" do
          ect.early_career_teacher_profile.design_our_own!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(ect.reload.last_sign_in_at).to be_nil
        end
      end

      context "when a user's induction programme choice is not yet known" do
        it "renders sign_in page" do
          ect.early_career_teacher_profile.not_yet_known!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(response).to render_template(:new)
        end

        it "does not sign in the user" do
          ect.early_career_teacher_profile.not_yet_known!
          post "/users/sign_in", params: { user: { email: ect.email } }
          expect(ect.reload.last_sign_in_at).to be_nil
        end
      end
    end

    context "when a mentor is trying to log in" do
      let(:mentor) { create(:user, :mentor) }

      context "when email matches a mentor" do
        it "redirects to dashboard" do
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to redirect_to(dashboard_path)
          expect(mentor.reload.last_sign_in_at).not_to be_nil
        end
      end

      context "when a user isn't registered but has accessed the service prior to public beta" do
        it "redirects to dashboard" do
          mentor.mentor_profile.update!(registration_completed: false)
          InviteEmailEct.create!(user: mentor, sent_at: Time.zone.now)
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to redirect_to(dashboard_path)
          expect(mentor.reload.last_sign_in_at).not_to be_nil
        end
      end

      context "when a user isn't registered and has not accessed the service prior to public beta" do
        it "redirects to dashboard" do
          mentor.mentor_profile.update!(registration_completed: false)
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
          expect(mentor.reload.last_sign_in_at).to be_nil
        end
      end

      context "when a user's induction programme choice is a full induction programme" do
        it "renders sign_in page" do
          mentor.mentor_profile.full_induction_programme!
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
        end
      end

      context "when a user's induction programme choice has no early career teachers" do
        it "renders sign_in page" do
          mentor.mentor_profile.no_early_career_teachers!
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
        end
      end

      context "when a user is doing a designed induction programme" do
        it "renders sign_in page" do
          mentor.mentor_profile.design_our_own!
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
        end
      end

      context "when a user's induction programme choice is not yet known" do
        it "renders sign_in page" do
          mentor.mentor_profile.not_yet_known!
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
        end
      end

      context "when a user has no CIP specified" do
        it "renders sign_in page" do
          mentor.mentor_profile.update!(core_induction_programme: nil)
          post "/users/sign_in", params: { user: { email: mentor.email } }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when email matches an admin" do
      let(:user) { create(:user, :admin) }
      let(:login_url_regex) { /http:\/\/www\.example\.com\/users\/confirm-sign-in\?login_token=.*/ }
      let(:token_expiry_regex) { /\d\d:\d\d/ }

      before do
        allow(UserMailer).to receive(:sign_in_email).and_call_original
      end

      it "renders email sent" do
        post "/users/sign_in", params: { user: { email: user.email } }
        expect(response).to render_template(:login_email_sent)
        expect(user.reload.last_sign_in_at).to be_nil
      end

      context "when email case-insensitively matches a user" do
        def randomize_case(string)
          string.chars.map { |char| char.send(%i[upcase downcase].sample) }.join
        end

        it "sends a log_in email request to User Mailer" do
          expect(UserMailer).to receive(:sign_in_email).with(
            hash_including(
              user: user,
              url: login_url_regex,
              token_expiry: token_expiry_regex,
            ),
          )
          post "/users/sign_in", params: { user: { email: randomize_case(user.email) } }
        end
      end
    end
  end

  describe "GET /users/confirm-sign-in" do
    context "when user is an admin" do
      let(:user) { create(:user, :admin) }

      it "renders the redirect_from_magic_link template" do
        get "/users/confirm-sign-in?login_token=#{user.login_token}"
        expect(assigns(:login_token)).to eq(user.login_token)
        expect(response).to render_template(:redirect_from_magic_link)
      end

      it "redirects to link invalid when the token doesn't match" do
        get "/users/confirm-sign-in?login_token=aaaaaaaaaa"

        expect(response).to redirect_to "/users/link-invalid"
      end

      context "when the token has expired" do
        before { user.update!(login_token_valid_until: 1.hour.ago) }

        it "redirects to link invalid" do
          get "/users/confirm-sign-in?login_token=#{user.login_token}"

          expect(response).to redirect_to "/users/link-invalid"
        end
      end
    end

    context "when already signed in" do
      before { sign_in user }

      it "redirects to the dashboard" do
        get "/users/confirm-sign-in?login_token=aaaaaaaaaa"

        expect(response).to redirect_to "/dashboard"
      end
    end
  end

  describe "POST /users/sign-in-with-token" do
    context "when user is an admin" do
      let(:user) { create(:user, :admin) }

      it "redirects to dashboard" do
        post "/users/sign-in-with-token", params: { login_token: user.login_token }
        expect(response).to redirect_to(dashboard_path)
        expect(user.reload.last_sign_in_at).not_to be_nil
      end
    end

    context "when the login_token has expired" do
      before { user.update(login_token_valid_until: 2.days.ago) }

      it "redirects to link invalid page" do
        post "/users/sign-in-with-token", params: { login_token: user.login_token }
        expect(response).to redirect_to(users_link_invalid_path)
        expect(user.reload.last_sign_in_at).to be_nil
      end
    end
  end
end
