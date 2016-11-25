class UrlCleaner
  BLACKLIST = %w(
    utm_
  )
  attr_reader :uri

  class << self
    def clean(url)
      self.new(url).clean
    end
  end

  def initialize(url)
    @uri = URI(url)
  end

  def clean
    uri.query = clean_encoded_query_params.presence if uri.query
    uri.to_s
  end

  private

  def decoded_query_params
    URI.decode_www_form(uri.query)
  end

  def clean_encoded_query_params
    URI.encode_www_form(clean_query_params)
  end

  def clean_query_params
    decoded_query_params.reject do |key, value|
      BLACKLIST.each do |prefix|
        key.start_with?(prefix)
      end.any?
    end
  end
end
