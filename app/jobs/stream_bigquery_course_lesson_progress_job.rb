# frozen_string_literal: true

class StreamBigqueryCourseLessonProgressJob < ApplicationJob
  def perform(course_lesson_progress)
    bigquery = Google::Cloud::Bigquery.new
    dataset = bigquery.dataset "engage_and_learn", skip_lookup: true
    table = dataset.table "course_lesson_progress_#{Rails.env.downcase}", skip_lookup: true

    rows = [
      {
        "course_lesson_progresses.early_career_teacher_profile_id" => course_lesson_progress.early_career_teacher_profile_id,
        "course_lesson_progresses.course_lesson_id" => course_lesson_progress.course_lesson_id,
        "course_lesson_progresses.created_at" => course_lesson_progress.created_at,
        "course_lesson_progresses.updated_at" => course_lesson_progress.updated_at,
        "course_lesson_progresses.progress" => course_lesson_progress.progress,
      },
    ]

    table.insert rows
  end
end
