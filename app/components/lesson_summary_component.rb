# frozen_string_literal: true

class LessonSummaryComponent < ViewComponent::Base
  def initialize(lesson:, user:)
    @lesson = lesson
    @user = user
  end
end
