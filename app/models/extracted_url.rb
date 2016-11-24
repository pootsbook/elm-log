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

  def archive!
    update!(archived_at: Time.now)
  end

  def next
    self.class.canonical.active.next(created_at).first
  end

  def prev
    self.class.canonical.active.prev(created_at).first
  end
end
