# frozen_string_literal: true

module TrainingAndSupportHelper
  def guidance_question_header(user)
    if user.is_an_nqt_plus_one_ect?
      "Before you start, would you like a brief guide on how to get the best out of these materials?"
    else
      "Before you start, would you like a brief summary of the programme?"
    end
  end
end
