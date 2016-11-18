class Tweet < ActiveRecord::Base
  serialize :raw, HashSerializer

  def original
    Twitter::Tweet.new(raw)
  end
end
