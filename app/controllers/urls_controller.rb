class UrlsController < ApplicationController
  before_action :verify_signed_in

  def index
    @unprocessed_tweet_count = Tweet.unprocessed.count
    if filter = params[:filter]
      @urls = ExtractedUrl.canonical.active.like(filter)
    else
      @urls = ExtractedUrl.canonical.active
    end
  end

  def show
    @url = ExtractedUrl.find(params[:id])
  end
end
