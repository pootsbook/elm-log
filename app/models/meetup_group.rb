class MeetupGroup < ActiveRecord::Base
  validates_uniqueness_of :urlname
end
