# frozen_string_literal: true

class SubnavComponent < ViewComponent::Base
  include ViewComponent::SlotableV2

  renders_many :nav_items, "NavItemComponent"

  class NavItemComponent < ViewComponent::Base
    attr_reader :path

    def initialize(path:)
      @path = path
    end
  end
end
