class FileItem < ActiveRecord::Base
  belongs_to :folder

  validates :folder_id,
    presence: true

  validates :name,
    presence: true,
    uniqueness: {
      scope: :folder_id,
      case_sensitive: false
    }

  def copy(target_folder)
    new_file = self.dup
    new_file.folder = target_folder
    new_file.save!
    new_file
  end
end
