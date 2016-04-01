class Event < ActiveRecord::Base
  attr_accessor :time_zone

  def local_starts_at
    starts_at.getlocal(utc_offset_fmt)
  end

  scope :this_week, -> do
    now = Time.zone.now
    three_hours_ago = now - 3.hours
    eight_days_later = now + 8.days
    where(starts_at: three_hours_ago..eight_days_later)
  end

  scope :this_month, -> do
    now = Time.zone.now
    three_hours_ago = now - 3.hours
    thirty_days_later = now + 30.days
    where(starts_at: three_hours_ago..thirty_days_later)
  end

  scope :last_week, -> do
    now = Time.zone.now
    eight_days_ago = now - 8.days
    where(starts_at: eight_days_ago..now)
  end

  scope :last_month, -> do
    now = Time.zone.now
    thirty_days_ago = now + 30.days
    where(starts_at: thirty_days_ago..now)
  end

  scope :upcoming, -> do
    now = Time.zone.now
    three_hours_ago = now - 3.hours

    where('starts_at > ?', three_hours_ago)
  end

  scope :occurred, -> do
    where('starts_at < ?', Time.zone.now)
  end
end
