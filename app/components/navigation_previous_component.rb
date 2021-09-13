# frozen_string_literal: true

class NavigationPreviousComponent < BaseComponent
  def initialize(url:, text:)
    @url = url
    @text = text
  end
end
