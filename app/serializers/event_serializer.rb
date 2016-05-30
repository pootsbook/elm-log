class EventSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :description,
    :country,
    :city,
    :host,
    :url,
    :local_starts_at
end
