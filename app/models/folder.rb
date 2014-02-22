require 'validators/ancestry_uniqueness'

class Folder < ActiveRecord::Base
  has_ancestry

  has_many :file_items, dependent: :destroy
  belongs_to :user

  validates :name,
    presence: true,
    ancestry_uniqueness: true
end
