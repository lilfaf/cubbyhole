require 'validators/email'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :folders, dependent: :delete_all

  has_one :root_folder,
    ->(obj) { obj.folders.where(name: 'root', ancestry: nil) },
    class_name: 'Folder'

  validates :username,
    presence: true,
    uniqueness: true,
    length: { maximum: 80 }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    email: true

  # Create user root folder on creation callback
  before_create -> { build_root_folder(name: 'root') }

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
