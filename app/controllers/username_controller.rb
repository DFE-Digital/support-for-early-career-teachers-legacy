# frozen_string_literal: true

class UsernameController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def update
    current_user.username = params[:user][:username]
    current_user.save!

    redirect_to dashboard_path
  end
end
