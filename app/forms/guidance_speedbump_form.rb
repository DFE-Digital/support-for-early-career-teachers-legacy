# frozen_string_literal: true

class GuidanceSpeedbumpForm
  include ActiveModel::Model

  attr_accessor :view_guidance_option

  def guidance_speedbump_options
    [
      OpenStruct.new(id: "view_guidance", name: "Yes, that would be useful"),
      OpenStruct.new(id: "skip_guidance", name: "No, I know what to expect"),
    ]
  end
end
