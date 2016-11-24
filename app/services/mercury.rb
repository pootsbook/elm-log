require "net/http"
require "uri"

class Mercury
  ENDPOINT = 'https://mercury.postlight.com/parser?url='

  def self.fetch_summary(url)
    uri = URI.parse(ENDPOINT+url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)

    request['Content-Type'] = 'application/json'
    request['x-api-key'] = ENV['MERCURY_API_KEY']

    response = http.request(request)
    JSON.parse(response.body)
  end
end
