class Folder < ActiveRecord::Base
  acts_as_nested_set scope: :user_id

  has_many :file_items, dependent: :destroy
  belongs_to :user

  validates :name,
    presence: true,
    uniqueness: {
      scope: :parent_id,
      case_sensitive: false
    }

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
end
