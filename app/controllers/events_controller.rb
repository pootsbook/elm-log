class EventsController < ApplicationController
  # before_action :verify_signed_in, only: [:new, :create]

  def index
    @events = Event.upcoming.order(starts_at: :asc)
  end

  def new
    @event = Event.new
  end

  def create
    if params[:link_only]
      @event = MeetupScraper.new.scrape_from_meetup_url(params[:event][:url])
      redirect_to event_path(@event)
    else
      @event = Event.new(event_params_processed_for_time_zone)
      if @event.save(context: :direct_input)
        redirect_to event_path(@event), notice: "Success"
      else
        render :new
      end
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
    @event.starts_at = Time.zone.local_to_utc(@event.local_starts_at)
  end

  def update
    @event = Event.find(params[:id])
    @event.attributes = event_params_processed_for_time_zone
    if @event.save(context: :direct_input)
      redirect_to event_path(@event), notice: "Success"
    else
      render :edit
    end
  end

  private

  def event_params_processed_for_time_zone
    TimeZoneParamsProcessor.process(event_params)
  end

  def event_params
    attrs = [
      :title,
      :starts_at,
      :time_zone,
      :host,
      :city,
      :country,
      :description,
      :url
    ]
    params.require(:event).permit(*attrs)
  end
end
