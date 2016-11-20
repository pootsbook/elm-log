class ExtractedUrl < ActiveRecord::Base
  belongs_to :canonical_url,
    class_name: 'ExtractedUrl'
  has_many :extracted_urls,
    foreign_key: 'canonical_url_id'
  belongs_to :source, polymorphic: true

  scope :canonical, -> { where(canonical_url_id: nil) }
  scope :like, ->(match) { where('url ILIKE ?', "%#{match}%") }
end
