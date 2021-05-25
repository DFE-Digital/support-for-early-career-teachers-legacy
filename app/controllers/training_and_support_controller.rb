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
end
