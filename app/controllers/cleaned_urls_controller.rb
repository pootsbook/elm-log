class CleanedUrlsController < ApplicationController
  before_action :verify_signed_in

  def create
    url = ExtractedUrl.find(params[:id])
    url.clean!
    redirect_to urls_path(filter: params[:filter])
  end
end
