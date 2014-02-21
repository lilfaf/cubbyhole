require 'validators/email'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :folders
  has_many :c_files

  validates :username,
    presence: true,
    uniqueness: true,
    length: { maximum: 80 }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    email: true

  # Allow users to sign in using their username or email address
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
