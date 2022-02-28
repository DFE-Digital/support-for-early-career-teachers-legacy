# frozen_string_literal: true

class ExternalUsersHomeController < ApplicationController
  include Pundit
  include CipBreadcrumbHelper

  before_action :authenticate_user!
  helper_method :cip_link

  def show
    authorize CoreInductionProgramme
    @core_induction_programmes = CoreInductionProgramme.all
  end

  def cip_link(core_induction_programme)
    govuk_link_to core_induction_programme.name, cip_path(core_induction_programme)
  end
end
