class Identity < ActiveRecord::Base

  validates_presence_of :uid, :provider, :email, :nickname

  serialize :raw

  def self.find_or_create_from_omniauth(hash)
    if identity = self.find_from_omniauth(hash)
      self.update_from_omniauth(identity, hash)
    else
      self.create_from_omniauth(hash)
    end
  end

  def self.find_from_omniauth(hash)
    Identity.find_by(provider: hash['provider'], uid: hash['uid'].to_s)
  end

  def self.update_from_omniauth(identity, hash)
    identity.update_attributes!(
      name: hash['info']['name'],
      email: hash['info']['email'],
      nickname: hash['info']['nickname'],
      image: hash['info']['image'],
      location: hash['extra']['raw_info']['location'],
      description: hash['extra']['raw_info']['bio'],
      raw: hash
    )
    identity
  end

  def self.create_from_omniauth(hash)
    Identity.create!(
      provider: hash['provider'],
      uid: hash['uid'],
      name: hash['info']['name'],
      email: hash['info']['email'],
      nickname: hash['info']['nickname'],
      image: hash['info']['image'],
      location: hash['extra']['raw_info']['location'],
      description: hash['extra']['raw_info']['bio'],
      raw: hash
    )
  end
end
