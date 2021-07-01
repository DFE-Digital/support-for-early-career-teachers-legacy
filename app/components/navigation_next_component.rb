# frozen_string_literal: true

class NavigationNextComponent < BaseComponent
  def initialize(url:, text:)
    @url = url
    @text = text
  end
end
