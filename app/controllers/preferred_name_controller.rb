# frozen_string_literal: true

class PreferredNameController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def update
    current_user.update!(user_params)
    redirect_to dashboard_path
  end

private

  def user_params
    params.require(:user).permit(:preferred_name)
  end
end
