# frozen_string_literal: true

class MentorMaterial < ApplicationRecord
  # TODO: hopefully remove some of those
  belongs_to :core_induction_programme, optional: true
  belongs_to :course_year, optional: true
  belongs_to :course_module, optional: true
  belongs_to :course_lesson, optional: true

  validates :title, presence: { message: "Enter a title" }, length: { maximum: 255 }
  validates :content, presence: { message: "Enter content" }, length: { maximum: 2_000_000 }

  def content_to_html
    Govspeak::Document.new(content, options: { allow_extra_quotes: true }).to_html
  end
end
