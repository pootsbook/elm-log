class Tweet < ActiveRecord::Base
  serialize :raw, HashSerializer

  scope :unprocessed, -> { where(processed: false) }

  class << self
    def process!
      unprocessed.find_each do |tweet|
        tweet.process!
      end
    end
  end

  def original
    Twitter::Tweet.new(raw)
  end

  def process!
    UrlExtractor.new(self).extract!
    update!(processed: true)
  end
end
