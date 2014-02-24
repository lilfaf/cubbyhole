require 'validators/ancestry_uniqueness'

class Folder < ActiveRecord::Base
  ROOT_NAME = 'root'

  has_ancestry

  has_many :file_items, dependent: :destroy
  belongs_to :user

  validates :name,
    presence: true,
    ancestry_uniqueness: true

  validate :ensure_valid_parent, unless: -> { is_root? }

  before_destroy :prevent_root_deletion

  def is_root?
    parent.nil? && user && name == ROOT_NAME
  end

  private

  def ensure_valid_parent
    errors.add(:parent, :invalid) if parent.nil?
  end

  def prevent_root_deletion
    raise "Root folder can't be deleted" if is_root?
  end
end
