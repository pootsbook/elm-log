class RootDomainConstraint
  attr_accessor :subdomains

  def initialize(*subdomains)
    @subdomains = subdomains
  end

  def matches?(request)
    request.host.match(/^(?!#{subdomains.join('|')}\.)/i).present?
  end
end
