# frozen_string_literal: true

class LessonNewPositionComponent < ViewComponent::Base
  attr_reader :lesson, :form

  def initialize(lesson:, form:)
    @lesson = lesson
    @form = form
  end

  def collection
    array = (lesson.course_module.course_lessons - [lesson]).each_with_index.map do |l, index|
      OpenStruct.new(title: l.title, position: index + 2)
    end

    array.compact!

    array.prepend(OpenStruct.new(title: "Set as first lesson", position: 1))

    array
  end

  def selected
    lesson.position
  end

  def render?
    lesson.persisted?
  end
end
