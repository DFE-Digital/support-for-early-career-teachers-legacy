# frozen_string_literal: true

module ApplicationHelper
  def service_name_for(user = nil)
    return "Mentoring for early career teachers" if user&.mentor?

    "Support for early career teachers"
  end
end
