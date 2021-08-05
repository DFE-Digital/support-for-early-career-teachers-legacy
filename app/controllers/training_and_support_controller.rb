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

    if @guidance_speedbump_form.view_guidance_option.blank?
      @guidance_speedbump_form.errors.add :view_guidance_option, "Select if you would like a brief summary of the programme"
      render :guidance_question and return
    end

    current_user.participant_profile.update!(guidance_seen: true)

    if view_guidance?(@guidance_speedbump_form)
      redirect_to training_and_support_path
    else
      redirect_to cip_path(current_user.core_induction_programme)
    end
  end

  def guidance_question
    @guidance_speedbump_form = GuidanceSpeedbumpForm.new
  end

private

  def view_guidance?(guidance_speedbump_form)
    guidance_speedbump_form.view_guidance_option == "view_guidance"
  end

  def guidance_question_params
    params.fetch(:guidance_speedbump_form, {}).permit(:view_guidance_option)
  end
end
