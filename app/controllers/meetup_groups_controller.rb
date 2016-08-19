class MeetupGroupsController < ApplicationController
  before_action :verify_signed_in, except: [:index]

  def index
    @meetup_groups = MeetupGroup.order(city: :asc)
  end

  def new
    @meetup_group = MeetupGroup.new
  end

  def create
    @meetup_group = MeetupScraper.new.scrape_group(meetup_group_params[:urlname])
    redirect_to meetup_group_path(@meetup_group)
  end

  def show
    @meetup_group = MeetupGroup.find(params[:id])
  end

  private

  def meetup_group_params
    attrs = [
      :urlname
    ]
    params.require(:meetup_group).permit(*attrs)
  end
end
