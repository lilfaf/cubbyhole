require 'errors'

class Folder < ActiveRecord::Base
  ROOT_FOLER_NAME = 'cubbyhole_root_folder'

  acts_as_nested_set scope: :user_id

  has_many :file_items, dependent: :destroy
  belongs_to :user

  validates :name,
    presence: true,
    exclusion: %w(ROOT_FOLER_NAME),
    uniqueness: {
      scope: :parent_id,
      case_sensitive: false
    }

  validates :parent_id,
    presence: true,
    unless: -> { is_root? }

  before_destroy :prevent_root_deletion

  def is_root?
    parent.nil? && name == ROOT_FOLER_NAME
  end

  # Extends active record method to
  # prevent changes on the root folder
  def update_attributes(attributes)
    raise Errors::ForbiddenOperation if is_root?
    super(attributes)
  end

  attr_accessor :copied_folder

  # This makes a deep clone of the folder
  # and assign it to the target
  def copy(target, copied_folder = nil)
    new_folder = self.dup
    new_folder.parent = target
    new_folder.save!

    copied_folder = new_folder if copied_folder.nil?

    self.file_items.each do |file|
      file.copy(new_folder)
    end

    self.children.each do |folder|
      unless folder == copied_folder
        folder.copy(new_folder, copied_folder)
      end
    end
    new_folder
  end

  private

  def prevent_root_deletion
    raise Errors::ForbiddenOperation, 'Root folder cannot be deleted' if is_root?
  end
end
