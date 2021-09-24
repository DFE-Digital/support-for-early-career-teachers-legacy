# frozen_string_literal: true

class UserMailer < ApplicationMailer
  MENTOR_WELCOME_TEMPLATE = "c0dc7dae-76e3-4346-8c2b-0d38aaf94a54"
  ECT_WELCOME_TEMPLATE = "652fea63-1344-4608-a957-6046dc27120b"
  SIGN_IN_EMAIL_TEMPLATE = "a3219fe5-e320-48ee-a386-7a244785785c"
  NQT_PLUS_ONE_WELCOME_TEMPLATE = "338059be-18d5-4ca6-9351-bb6d45bad2ae"
  MENTOR_SIGN_IN_REMINDER_EMAIL = "7dce3037-50fc-46ed-b070-a7e10e2f4379"

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

  def nqt_plus_one_welcome_email(user)
    start_url = Rails.application.routes.url_helpers.root_url(host: Rails.application.config.domain,
                                                              **UtmService.email(:new_nqt_plus_one))
    template_mail(
      NQT_PLUS_ONE_WELCOME_TEMPLATE,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        full_name: user.full_name,
        start_url: start_url,
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

  def mentor_sign_in_reminder_email(user)
    sign_in_url = Rails.application.routes.url_helpers.new_user_session_url(host: Rails.application.config.domain,
                                                                            **UtmService.email(:new_mentor))
    template_mail(
      MENTOR_SIGN_IN_REMINDER_EMAIL,
      to: user.email,
      rails_mailer: mailer_name,
      rails_mail_template: action_name,
      personalisation: {
        full_name: user.full_name,
        sign_in_url: sign_in_url,
      },
    )
  end
end
