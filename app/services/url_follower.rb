class UrlFollower
  def self.follow(url)
    case response = Net::HTTP.get_response(URI(url))
    when Net::HTTPSuccess
      url
    when Net::HTTPRedirection
      follow(response['Location'])
    end
  rescue => e
    Rails.logger.warn("UrlFollower failed for #{url} with #{e.inspect}")
  end
end
