# frozen_string_literal: true

class UtmService
  CAMPAIGNS = {
    new_mentor: "new-mentor",
    new_early_career_teacher: "new-early-career-teacher",
    new_nqt_plus_one: "new-nqt-plus-one",
    sign_in: "sign-in",
    mentor_sign_in_reminder: "mentor-sign-in-reminder",
    new_external_user: "new-external-user"
  }.freeze

  def self.email(campaign)
    {
      utm_source: "cpdservice",
      utm_medium: "email",
      utm_campaign: CAMPAIGNS[campaign] || "none",
    }
  end
end
