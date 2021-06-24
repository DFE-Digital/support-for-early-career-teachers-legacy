# frozen_string_literal: true

class CoreInductionProgrammes::ProviderController < ApplicationController
  def load_core_induction_programme
    @core_induction_programme = CoreInductionProgramme.find_by slug: params[:provider_id]

    unless @core_induction_programme
      raise ActionController::RoutingError, "Core Induction Programme not found"
    end
  end
end
