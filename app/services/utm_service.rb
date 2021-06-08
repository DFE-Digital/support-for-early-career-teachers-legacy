# frozen_string_literal: true

class UtmService
  CAMPAIGNS = {
    new_mentor: "new-mentor",
    new_early_career_teacher: "new-early-career-teacher",
    sign_in: "sign-in",
  }.freeze

  def self.email(campaign)
    {
      utm_source: "cpdservice",
      utm_medium: "email",
      utm_campaign: CAMPAIGNS[campaign] || "none",
    }
  end
end
