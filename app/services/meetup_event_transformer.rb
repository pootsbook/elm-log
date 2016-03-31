class MeetupEventTransformer

  MILLISECONDS = 1000
  SECONDS      = 60
  MINUTES      = 60

  def self.transform(event)
    new.transform(event)
  end

  def transform(event)
    {
      title: event.fetch("name"),
      description: event.fetch("description"),
      starts_at: parse_meetup_time(event.fetch("time")),
      city: event.dig("venue", "city"),
      country: event.dig("venue", "localized_country_name"),
      host: event.dig("group", "name"),
      url: event.fetch("event_url"),
      utc_offset_fmt: parse_utc_offset(event.fetch("utc_offset")),
      utc_offset: utc_offset_in_seconds(event.fetch("utc_offset")),
      external_id: event.fetch("id"),
      external_updated_at: event.fetch("updated").to_s
    }
  end

  private

  def parse_meetup_time(milliseconds_since_epoch)
    seconds = milliseconds_since_epoch / 1000
    DateTime.strptime(seconds.to_s, "%s")
  end

  def utc_offset_in_seconds(utc_offset_in_milliseconds)
    utc_offset_in_milliseconds / MILLISECONDS
  end

  def parse_utc_offset(utc_offset_in_milliseconds)
    hours = utc_offset_in_milliseconds / MILLISECONDS / SECONDS / MINUTES
    signifier = hours >= 0 ? "+" : "-"
    padder = hours > 9 ? "" : "0"
    "#{signifier}#{padder}#{hours.abs}:00"
  end
end
