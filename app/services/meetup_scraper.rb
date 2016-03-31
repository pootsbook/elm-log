class MeetupScraper

  def self.scrape
    new.scrape
  end

  def scrape
    meetup_events = elm_meetups.map do |urlname|
      $meetup.events({ group_urlname: urlname })["results"]
    end.flatten

    
    existing_external_events = Event.pluck(:external_id, :external_updated_at)
    existing_external_ids = existing_external_events.map(&:first)

    # Destroy DB Events if they have since been updated
    meetup_events.each do |event|
      meetup_event_id = event.fetch("id")
      meetup_event_updated = event.fetch("updated").to_s
      index = existing_external_ids.index(meetup_event_id)
      if index && existing_external_events[index].last != meetup_event_updated
        Event.find_by(external_id: meetup_event_id).destroy
        existing_external_ids.slice!(index)
      end
    end

    # Reject Meetup Events if they already exist in DB
    meetup_events.reject! do |event|
      existing_external_ids.include?(event.fetch("id"))
    end

    meetup_events.each do |event|
      persist_event(transform_event(event))
    end
  end

  private

  def transform_event(event)
    MeetupEventTransformer.transform(event)
  end

  def persist_event(params)
    Event.create(params)
  end

  def elm_meetups
    %w(
      Elm-user-group-SF
      Elm-User-Group-Dublin
      Elm-Warsaw
      Tokyo-Elm-Programming-Meetup
      Boston-Elm
      portlandelm
      Elm-Copenhagen
      ElmShop
      Boston-Elm-Lang-Meetup
      Elm-User-Group-DC
      Elm-London-Meetup
      STLElm
      Elm-NYC
      Stockholm-Elm
      Seattle-Elm
      Meetup-Elm-Paris
      chicago-elm
      Utah-Elm-Users
      Vienna-Elm-Meetup
      Elm-Berlin
      Elm-TLV
      Elmsinki
      berlin-elm-hackathon
      Elm-Wellington
    )
  end
end
