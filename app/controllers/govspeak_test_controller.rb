# frozen_string_literal: true

require "govspeak"

class GovspeakTestController < ApplicationController
  def show
    @preview_string = ""
  end

  def preview
    @preview_string = params[:preview_string]
    render :show
  end
end
