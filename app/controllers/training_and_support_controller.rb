# frozen_string_literal: true

class TrainingAndSupportController < ApplicationController
  before_action :authenticate_user!

  def show
    @provider = current_user.core_induction_programme

    if @provider.blank?
      raise Pundit::NotAuthorizedError, "This page is only available to CIP participants"
    end

    @provider_name_key = @provider.name.downcase.gsub(/ /, "_")
  end

  def update
    @participant = current_user.participant_profile

    if params[@participant.model_name.param_key].blank?
      @participant.errors.add :viewed_guidance, "Select if you would like a brief summary of the programme"
      render :guidance_question and return
    end

    @participant.update!(show_guidance_speedbump: false)

    if view_guidance?
      redirect_to training_and_support_path
    else
      redirect_to cip_path(current_user.core_induction_programme)
    end
  end

  def guidance_question
    @participant = current_user.participant_profile
  end

private

  def view_guidance?
    participant = current_user.participant_profile
    params[participant.model_name.param_key][:show_guidance_speedbump] == "view guidance"
  end
end
