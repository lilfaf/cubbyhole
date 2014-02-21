require 'validators/ancestry_uniqueness'

class Entry < ActiveRecord::Base
  has_ancestry

  belongs_to :user

  validates :name,
    presence: true,
    length: { maximum: 250 },
    ancestry_uniqueness: true
end
