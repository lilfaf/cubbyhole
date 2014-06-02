require 'errors'

class ShareLink < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :asset
  has_many :emails

  before_save :set_default_expiration_delay
  before_save :generate_token

  def self.asset_for_token(token)
    link = where(token: token).first

    if link.expires_at < DateTime.now
      raise Errors::ForbiddenOperation
    end
    link.asset
  end

  private

  def set_default_expiration_delay
    self.expires_at = 2.weeks.from_now
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless ShareLink.exists?(token: random_token)
    end
  end
end

