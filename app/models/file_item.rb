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
end
