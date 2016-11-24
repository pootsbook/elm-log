require 'net/http'
require 'uri'

class UrlExtractor
  attr_reader :tweet, :original

  def initialize(tweet)
    @tweet = tweet
    @original = tweet.original
  end

  def extract!
    expanded_urls.map do |url|
      UrlFollower.follow(url)
    end.compact.map do |url|
      persist_url(url)
    end
  end


  private

  def expanded_urls
    return [] unless original.uris?
    original.uris.map do |uri|
      uri.expanded_url.to_s
    end
  end

  def persist_url(url)
    ActiveRecord::Base.transaction do
      canonical_url = ExtractedUrl.find_by(url: url, canonical_url_id: nil)
      ExtractedUrl.create!(url: url, source: tweet, canonical_url: canonical_url)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("RecordInvalid ExtractedUrl from ::Tweet #{tweet.id} with url #{url}")
  rescue Errno::ECONNREFUSED => e
    Rails.logger.warn("RecordInvalid ExtractedUrl from ::Tweet #{tweet.id} with url #{url}")
  end
end
