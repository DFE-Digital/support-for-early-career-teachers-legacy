# frozen_string_literal: true

module ApplicationHelper
  def service_name_for(current_user = nil)
    return "Mentoring for early career teachers" if current_user&.mentor?

    "Support for early career teachers"
  end
end
