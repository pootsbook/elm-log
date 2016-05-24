class MeetupScraper
  class RateLimitExceeded < StandardError; end

  def self.scrape
    new.scrape
  end

  def scrape_from_meetup_url(url)
    event_id = url.split("/").last
    scrape_event(event_id).first
  end

  def scrape_group(group_urlname)
    meetup_group = $meetup.groups({ group_urlname: group_urlname })["results"][0]
    process_group_response(meetup_group)
  end

  def scrape_event(event_id)
    meetup_events = $meetup.events({ event_id: event_id })["results"]
    process_events_response(meetup_events)
  end

  def scrape_past_events
    meetup_events = elm_meetups.map do |urlname|
      $meetup.events({ group_urlname: urlname, status: 'past' })
    end.flatten
    process_events_response(meetup_events)
  end

  def scrape
    fetch_meetup_events
  rescue RateLimitExceeded
  ensure
    process_events_response(@meetup_events.flatten.compact)
  end

  def fetch_meetup_events
    @meetup_events = []
    elm_meetups.reverse.each do |urlname|
      response = $meetup.events({ group_urlname: urlname })
      raise RateLimitExceeded if ["bad_request", "blocked", "throttled"].include?(response["code"])
      @meetup_events << response["results"]
    end
    @meetup_events
  end

  def process_group_response(group)
    MeetupGroup.find_by!(urlname: group["urlname"])
  rescue ActiveRecord::RecordNotFound
    create_meetup_group_from_params(group)
  end

  def create_meetup_group_from_params(params)
    transformer = MeetupTransformer.new
    MeetupGroup.create({
      description:         params.dig("description"),
      name:                params.dig("name"),
      city:                params.dig("city"),
      state:               params.dig("state"),
      country:             params.dig("country"),
      url:                 params.dig("link"),
      external_id:         params.dig("id"),
      utc_offset_fmt:      transformer.parse_utc_offset(params.dig("utc_offset")),
      time_zone:           params.dig("timezone"),
      urlname:             params.dig("urlname"),
      photo_highres:       params.dig("group_photo", "highres_link"),
      photo_thumb:         params.dig("group_photo", "thumb_link"),
      photo:               params.dig("group_photo", "photo_link"),
      member_count:        params.dig("members"),
      utc_offset:          transformer.utc_offset_in_seconds(params.dig("utc_offset")),
      external_created_at: DateTime.strptime(params.dig("created").to_s, '%Q')
    })
  end

  private

  def process_events_response(events_list)
    return false if events_list.empty?

    # Ascertain contents of the DB
    existing_external_events = Event.pluck(:external_id, :external_updated_at)
    existing_external_ids = existing_external_events.map(&:first)

    # Destroy DB Events if they have since been updated
    events_list.each do |event|
      meetup_event_id = event.fetch("id")
      meetup_event_updated = event.fetch("updated").to_s
      index = existing_external_ids.index(meetup_event_id)
      if index && existing_external_events[index].last != meetup_event_updated
        Event.find_by(external_id: meetup_event_id).destroy
        existing_external_ids.slice!(index)
      end
    end

    # Reject Meetup Events if they already exist in DB
    events_list.reject! do |event|
      existing_external_ids.include?(event.fetch("id"))
    end

    events_list.map do |event|
      persist_event(transform_event(event))
    end
  end

  def transform_event(event)
    MeetupEventTransformer.transform(event)
  end

  def persist_event(params)
    Event.create(params)
  end

  def elm_meetups
    MeetupGroup.pluck(:urlname)
  end
end
