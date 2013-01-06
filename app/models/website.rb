require 'addressable/uri'

class Website < ActiveRecord::Base
  attr_accessible :name, :url

  validates_presence_of :name, :url

  validate :url_must_be_reachable, on: :create

  def check
    response = HTTParty.head(url)
    self.status_code = response.code
    self.status_message = response.message
    self.checked_at = Time.now
    save
  end

  def self.check_all
    all.each { |w| w.check }
  end

  def container_class
    case status_code
    when 200
      "ok"
    when 300..399
      "redirect"
    when 400..599
      "error"
    else 
      "unknown"
    end
  end

  private

  def url_must_be_reachable
    return if url.blank?
    uri = Addressable::URI.parse(url)
    unless %w{ http https }.include?(uri.scheme) 
      errors.add(:url, "can only be HTTP or HTTPS")
      return
    end
    begin
      response = HTTParty.head(url)
    rescue SocketError
      errors.add(:url, "can't be reached")
      return
    end
  end
end
