class MeetupTransformer
  MILLISECONDS = 1000
  SECONDS      = 60
  MINUTES      = 60

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
