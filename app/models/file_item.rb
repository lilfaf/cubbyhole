class Asset < ActiveRecord::Base
  belongs_to :folder
  belongs_to :user

  mount_uploader :asset, AssetUploader

  validates :name,
    presence: true,
    uniqueness: {
      scope: :folder_id,
      case_sensitive: false
    }

  validates :key, presence: true
  validates :size, presence: true
  validates :content_type, presence: true
  validates :etag, presence: true

  default_scope { where(processed: true) }
  scope :roots, -> { where(folder_id: nil) }

  before_validation :set_metadata, on: :create

  def post_processing_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(content_type).present?
  end

  def set_metadata
    file = ::CarrierWave::Storage::Fog::File.new(asset, ::CarrierWave::Storage::Fog.new(asset), key)
    if file.exists?
      self.size = file.size
      self.content_type = file.content_type
      self.etag = file.attributes[:etag]
    end
  end

  def copy(target_folder)
    new_asset = self.dup
    new_asset.folder = target_folder
    new_asset.save!
    new_asset
  end
end
