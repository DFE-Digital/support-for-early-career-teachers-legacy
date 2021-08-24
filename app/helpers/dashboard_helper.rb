# frozen_string_literal: true

module DashboardHelper
  def start_button_text(user)
    if user.is_an_nqt_plus_one_ect?
      "Access your materials"
    else
      "Start now"
    end
  end

  def start_button_path(user)
    user.participant_profile.guidance_seen? ? cip_path(user.core_induction_programme) : guidance_question_path
  end

  def how_this_programme_works_path(_user)
    training_and_support_path
  end
 end
