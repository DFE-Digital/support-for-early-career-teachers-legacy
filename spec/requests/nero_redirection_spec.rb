# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NERO domain redirection", type: :request do
  let(:secondary_domain) { Rails.application.config.redirect_domain }
  let(:primary_domain) { Rails.application.config.domain }

  it "Does not redirect primary domain" do
    get "https://#{primary_domain}/"
    expect(response).to_not be_redirect
  end

  it "Redirects from secondary domain root to primary domain root" do
    get "https://#{secondary_domain}/"
    expect(response).to redirect_to "https://#{primary_domain}/"
  end

  it "Redirects from secondary domain path to primary domain root" do
    get "https://#{secondary_domain}/some-random-page"
    expect(response).to redirect_to "https://#{primary_domain}/"
  end
end
