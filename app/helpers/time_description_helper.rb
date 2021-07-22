# frozen_string_literal: true

module TimeDescriptionHelper
  def minutes_to_words(completion_time_in_minutes)
    return "" unless completion_time_in_minutes

    number_of_hours = completion_time_in_minutes / 60
    number_of_minutes = completion_time_in_minutes % 60

    hour_string = "hour".pluralize(number_of_hours)
    minute_string = "minute".pluralize(number_of_minutes)

    if number_of_hours.positive? && number_of_minutes.positive?
      "#{number_of_hours} #{hour_string} #{number_of_minutes} #{minute_string}"
    elsif number_of_hours.positive?
      "#{number_of_hours} #{hour_string}"
    else
      "#{number_of_minutes} #{minute_string}"
    end
  end
end
