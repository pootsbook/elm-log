class EventsController < ApplicationController
  before_action :verify_signed_in, only: [:new, :create]

  def index
    @events = Event.upcoming.order(starts_at: :asc)
  end

  def new
    @event = Event.new
  end

  def create
    if params[:link_only]
      MeetupScraper.new.scrape_from_meetup_url(params[:event][:url])
    end
    redirect_to events_path
  end
end
