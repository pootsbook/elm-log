module EventsHelper
  def date_and_time_display(time)
    time.to_formatted_s(:date_and_time)
  end
end
