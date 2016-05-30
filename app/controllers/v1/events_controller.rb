class V1::EventsController < ApplicationController
  def index
    @events = Event.upcoming.order(starts_at: :asc)
    render json: @events
  end
end
