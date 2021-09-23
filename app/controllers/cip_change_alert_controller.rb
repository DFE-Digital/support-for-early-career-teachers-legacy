# frozen_string_literal: true

class CipChangeAlertController < ApplicationController
  before_action :authenticate_user!

  def start; end

  def acknowledge_start
    cip_change_message&.destroy!
    redirect_to cip_path(current_user.core_induction_programme)
  end

  def guidance; end

  def acknowledge_guidance
    cip_change_message&.destroy!
    redirect_to training_and_support_path
  end

private

  def original_cip_name
    cip_change_message.original_cip.name
  end

  def new_cip_name
    cip_change_message.new_cip.name
  end

  helper_method :original_cip_name, :new_cip_name

  def cip_change_message
    @cip_change_message ||= current_user.cip_change_message
  end
end
