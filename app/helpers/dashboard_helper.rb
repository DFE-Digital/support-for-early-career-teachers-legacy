# frozen_string_literal: true

module DashboardHelper
  def start_button_text(user)
    if user.is_an_nqt_plus_one_ect?
      "Access your materials"
    else
      "Start now"
    end
  end
end
