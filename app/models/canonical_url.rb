class CanonicalUrl < ActiveRecord::Base
  has_many :extracted_urls
end
