# frozen_string_literal: true

class TrainingAndSupportController < ApplicationController
  before_action :authenticate_user!

  def show
    @provider = current_user.core_induction_programme

    if @provider.blank?
      raise Pundit::NotAuthorizedError, "This page is only available to CIP participants"
    end

    current_user.participant_profile.update!(guidance_seen: true)
    @provider_name_key = @provider.name.downcase.gsub(/ /, "_")
  end

  def update
    @guidance_speedbump_form = GuidanceSpeedbumpForm.new(guidance_question_params)

    render :guidance_question and return unless @guidance_speedbump_form.valid?

    current_user.participant_profile.update!(guidance_seen: true)

    if @guidance_speedbump_form.view_guidance?
      redirect_to training_and_support_path
    else
      redirect_to cip_path(current_user.core_induction_programme)
    end
  end

  def guidance_question
    @guidance_speedbump_form = GuidanceSpeedbumpForm.new
  end

private

  def guidance_question_params
    params.fetch(:guidance_speedbump_form, {}).permit(:view_guidance_option)
  end
end
