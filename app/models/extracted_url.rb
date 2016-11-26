class ExtractedUrl < ActiveRecord::Base
  belongs_to :canonical_url,
    class_name: 'ExtractedUrl'
  has_many :extracted_urls,
    foreign_key: 'canonical_url_id'
  belongs_to :source, polymorphic: true

  scope :canonical, -> { where(canonical_url_id: nil) }
  scope :active, -> { where(archived_at: nil) }
  scope :like, ->(match) { where('url ILIKE ?', "%#{match}%") }

  scope :next, -> (created_at) { where('created_at > ?', created_at).limit(1) }
  scope :prev, -> (created_at) { where('created_at < ?', created_at).order(created_at: :desc).limit(1) }

  def self.refeed_tweets
    canonical.active.like('twitter.com/').find_each do |extracted_url|
      begin
        tweet_id = extracted_url.url.split('/').last
        if ::Tweet.find_by_twitter_id(tweet_id).nil?
          object = $twitter.status(tweet_id)
          ::Tweet.create!(
            twitter_id: object.id,
            raw: object)
        end
        extracted_url.archive!
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.warn("RecordInvalid Tweet #{object.id}")
      end
    end
  end

  def archive!
    update!(archived_at: Time.now)
  end

  def clean_url!
    update!(url: UrlCleaner.clean(url))
  end

  def next(filter)
    if filter.present?
      self.class.canonical.active.like(filter).next(created_at).first
    else
      self.class.canonical.active.next(created_at).first
    end
  end

  def prev(filter)
    if filter.present?
      self.class.canonical.active.like(filter).prev(created_at).first
    else
      self.class.canonical.active.prev(created_at).first
    end
  end
end
