class TimeZoneParamsProcessor
  def self.process(params)
    new.process(params)
  end

  def process(params)
    params.deep_dup.tap do |obj|
      time_zone = ActiveSupport::TimeZone.new(obj['time_zone'])
      time_with_zone = time_zone.local(
       obj.delete('starts_at(1i)'),
       obj.delete('starts_at(2i)'),
       obj.delete('starts_at(3i)'),
       obj.delete('starts_at(4i)'),
       obj.delete('starts_at(5i)')
      )
      obj['starts_at'] = time_with_zone
      obj['utc_offset'] = time_with_zone.utc_offset
      obj['utc_offset_fmt'] = time_with_zone.formatted_offset
    end
  end
end
