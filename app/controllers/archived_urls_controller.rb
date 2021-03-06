class ArchivedUrlsController < ApplicationController
  before_action :verify_signed_in

  def create
    url = ExtractedUrl.find(params[:id])
    url.archive!
    if params[:detail]
      next_url = ExtractedUrl.canonical.active.order(created_at: :asc).limit(1)
      redirect_to url_path(next_url, filter: params[:filter])
    else
      redirect_to urls_path(filter: params[:filter])
    end
  end
end
