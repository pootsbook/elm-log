namespace 'twitter' do
  desc "Stream tweets"
  task stream: :environment do
    $twitter_stream.filter(track: 'elmlang') do |object|
      if object.is_a?(Twitter::Tweet)
        begin
          ::Tweet.create!(
            twitter_id: object.id,
            raw: object)
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.warn("RecordInvalid Tweet #{object.id}")
        end
      end
    end
  end

  desc "Fetch tweets"
  task :fetch, [:tweet_id] => :environment do |_, args|
    results = $twitter.search('elmlang filter:links',
      result_type: 'recent',
      count: 100,
      since_id: args[:tweet_id])
    tweets = results.reduce([]) {|sum, tweet| sum << tweet }
    failures = []
    tweets.each do |object|
      begin
        ::Tweet.create!(
          twitter_id: object.id,
          raw: object)
        putc '.'
      rescue ActiveRecord::RecordInvalid => e
        failures << object.id
        putc 'F'
      end
    end
    puts
    puts "Fetched #{tweets.count} tweets."
    if failures.present?
      puts "#{failures.count} failed: #{failures.join(',')}"
    end
  end
end
