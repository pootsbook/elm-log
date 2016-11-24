require "net/http"
require "uri"

class Embedly
  ENDPOINT = 'https://api.embedly.com/1/extract'

  def self.fetch_summary(url)
    params = {
      'key' => ENV['EMBEDLY_API_KEY'],
      'url' => URI.encode(url)
    }
    req_url = "#{ENDPOINT}?#{stringify_params(params)}"

    uri = URI.parse(req_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.stringify_params(params)
    params.map {|k,v| "#{k}=#{v}" }.join('&')
  end
end
