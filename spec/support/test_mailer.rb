# frozen_string_literal: true

class Mail::TestMailer
  def response
    OpenStruct.new(id: "test_id")
  end
end
