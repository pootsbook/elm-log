namespace 'export' do
  desc "Export newsletter events markdown"
  task newsletter_markdown: :environment do
    MeetupScraper.scrape
    Event.this_week.order(starts_at: :asc).each do |evt|
      date = evt.local_starts_at.strftime("%a #{evt.local_starts_at.day.ordinalize} %b")
      puts "#{date}, **#{evt.city}, #{evt.country}** [#{evt.host}](#{evt.url})  "
    end
  end 
end
