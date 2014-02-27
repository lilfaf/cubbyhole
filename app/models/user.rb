require 'validators/email'

class User < ActiveRecord::Base
  ROOT_FOLER_NAME = 'cubbyhole_root_folder' # Move dat shit to a global config var

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :folders, dependent: :delete_all

  has_one :root_folder,
    ->(obj) { obj.folders.where(name: ROOT_FOLER_NAME, parent_id: nil) },
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
  before_create -> { build_root_folder(name: ROOT_FOLER_NAME) }

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
