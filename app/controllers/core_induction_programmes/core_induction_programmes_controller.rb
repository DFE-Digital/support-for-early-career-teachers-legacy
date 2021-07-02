# frozen_string_literal: true

class CoreInductionProgrammes::CoreInductionProgrammesController < ApplicationController
  include Pundit
  include CipBreadcrumbHelper

  before_action :authenticate_user!
  before_action :load_core_induction_programme, only: :show

  def index
    authorize CoreInductionProgramme
    @core_induction_programmes = CoreInductionProgramme.all
  end

  def show
    data_layer.add_cip_info(@core_induction_programme)
    authorize @core_induction_programme
    redirect_to cip_year_path(@core_induction_programme, @core_induction_programme.course_year_one)
  end

  def download_export
    if current_user&.admin?
      CoreInductionProgrammeExporter.new.run

      send_file(
        Rails.root.join("db/seeds/cip_seed_dump.rb"),
        filename: "cip_seed_dump.rb",
        type: "text/plain",
      )
    else
      redirect_to cip_index_path
    end
  end

  def load_core_induction_programme
    @core_induction_programme = load_core_induction_programme_from_params
  end
end
