Time::DATE_FORMATS[:date_and_time] = lambda { |time|
  day_format = ActiveSupport::Inflector.ordinalize(time.day)
  time.strftime("%A #{day_format} %B %Y at %-l:%M%P")
}
