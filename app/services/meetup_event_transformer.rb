class MeetupEventTransformer

  def self.transform(event)
    new.transform(event)
  end

  def transform(event)
    transformer = MeetupTransformer.new
    {
      title: event.dig("name"),
      description: event.dig("description"),
      starts_at: DateTime.strptime(event.dig("time").to_s, '%Q'),
      city: event.dig("venue", "city"),
      country: event.dig("venue", "localized_country_name"),
      host: event.dig("group", "name"),
      url: event.dig("event_url"),
      utc_offset_fmt: transformer.parse_utc_offset(event.dig("utc_offset")),
      utc_offset: transformer.utc_offset_in_seconds(event.dig("utc_offset")),
      external_id: event.dig("id"),
      external_updated_at: event.dig("updated").to_s
    }
  end
end
