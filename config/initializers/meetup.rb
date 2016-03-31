require 'meetup_client'

MeetupClient.configure do |config|
  config.api_key = ENV['MEETUP_API_KEY']
end

$meetup = MeetupApi.new
