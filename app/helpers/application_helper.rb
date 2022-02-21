# frozen_string_literal: true

module ApplicationHelper
  def data_layer
    @data_layer ||= build_data_layer
  end

  def build_data_layer
    analytics_data = AnalyticsDataLayer.new
    analytics_data.add_user_info(current_user) if current_user
    analytics_data
  end

  def home_path(user)
    if user
      user.external_user? ? external_users_home_path : dashboard_path
    else
      cip_path
    end
  end
end
