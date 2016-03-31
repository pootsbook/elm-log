class MeetupEventTransformer

  def self.transform(event)
    new.transform(event)
  end

  def transform(event)
    {
      title: event.fetch("name"),
      description: event.fetch("description"),
      starts_at: parse_meetup_time(event.fetch("time")),
      location: event.dig("venue", "city"),
      url: event.fetch("event_url"),
      utc_offset: parse_utc_offset(event.fetch("utc_offset")),
      external_id: event.fetch("id")
    }
  end

  private

  def parse_meetup_time(milliseconds_since_epoch)
    seconds = milliseconds_since_epoch / 1000
    DateTime.strptime(seconds.to_s, "%s")
  end

  def parse_utc_offset(utc_offset_in_milliseconds)
    hours = utc_offset_in_milliseconds / 1000 / 60 / 60
    signifier = hours >= 0 ? "+" : "-"
    padder = hours > 9 ? "" : "0"
    "#{signifier}#{padder}#{hours.abs}:00"
  end
end
