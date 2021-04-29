# frozen_string_literal: true

class UserMailer < ApplicationMailer
  MENTOR_WELCOME_TEMPLATE = "c0dc7dae-76e3-4346-8c2b-0d38aaf94a54"
  ECT_WELCOME_TEMPLATE = "652fea63-1344-4608-a957-6046dc27120b"

  def mentor_welcome_email(user)
    sign_in_url = Rails.application.routes.url_helpers.new_user_session_url(host: Rails.application.config.domain)
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
    sign_in_url = Rails.application.routes.url_helpers.new_user_session_url(host: Rails.application.config.domain)
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
end
