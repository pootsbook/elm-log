class V1::LinksController < ApplicationController
  def index
    render json: ExtractedUrl.canonical.order(created_at: :desc)
  end
end
