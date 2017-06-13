class V1::MeetupGroupsController < ApplicationController
  def index
    render json: MeetupGroup.all
  end
end
