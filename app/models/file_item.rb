class FileItem < ActiveRecord::Base
  belongs_to :folder
  belongs_to :user

  validates :name,
    presence: true,
    uniqueness: {
      scope: :folder_id,
      case_sensitive: false
    }

  scope :roots, -> { where(folder_id: nil) }

  def copy(target_folder)
    new_file = self.dup
    new_file.folder = target_folder
    new_file.save!
    new_file
  end
end
