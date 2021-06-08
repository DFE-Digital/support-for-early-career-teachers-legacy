# frozen_string_literal: true

class UserMailer < ApplicationMailer
  MENTOR_WELCOME_TEMPLATE = "c0dc7dae-76e3-4346-8c2b-0d38aaf94a54"
  ECT_WELCOME_TEMPLATE = "652fea63-1344-4608-a957-6046dc27120b"
  SIGN_IN_EMAIL_TEMPLATE = "a3219fe5-e320-48ee-a386-7a244785785c"

  def mentor_welcome_email(user)
    sign_in_url = Rails.application.routes.url_helpers.new_user_session_url(host: Rails.application.config.domain,
                                                                            **UtmService.email(:new_mentor))
    template_mail(
      MENTOR_WELCOME_TEMPLATE,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        full_name: user.full_name,
        sign_in_url: sign_in_url,
      },
    )
  end

  def ect_welcome_email(user)
    sign_in_url = Rails.application.routes.url_helpers.new_user_session_url(host: Rails.application.config.domain,
                                                                            **UtmService.email(:new_early_career_teacher))
    template_mail(
      ECT_WELCOME_TEMPLATE,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        full_name: user.full_name,
        sign_in_url: sign_in_url,
      },
    )
  end

  def sign_in_email(user:, url:, token_expiry:)
    template_mail(
      SIGN_IN_EMAIL_TEMPLATE,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        full_name: user.full_name,
        sign_in_url: url,
        token_expiry: token_expiry,
      },
    )
  end
end
