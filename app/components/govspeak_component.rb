# frozen_string_literal: true

class GovspeakComponent < BaseComponent
  def initialize(content:)
    @content = Govspeak::Document.new(content, options: { allow_extra_quotes: true }).to_html
  end
end
