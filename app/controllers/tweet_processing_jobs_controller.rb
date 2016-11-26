class TweetProcessingJobsController < ApplicationController
  before_action :verify_signed_in

  def create
    Tweet.process!
    redirect_to(urls_path)
  end
end
