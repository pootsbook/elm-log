class MeetupScraper

  def self.scrape
    new.scrape
  end

  def scrape
    events = elm_meetups.map do |urlname|
      $meetup.events({ group_urlname: urlname })["results"]
    end.flatten

    #TODO
    # Union of DB and Fetched list
    # Reject events with identical start_times
    # Delete corresponding events from DB
    # Process events into DB

    # Reject events with an external id
    #existing_external_events = Event.pluck(:external_id, :external_updated_at)
    #existing_external_ids = existing_external_events.map(&:first)

    #events.reject! do |event|
    #  existing_external_ids.include?(event.fetch("id"))
    #end

    events.each do |event|
      persist_event(transform_event(event))
    end
  end

  private

  def transform_event(event)
    MeetupEventTransformer.transform(event)
  end

  def persist_event(params)
    # Event.create(params)
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
