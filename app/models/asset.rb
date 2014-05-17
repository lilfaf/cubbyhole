class Asset < ActiveRecord::Base
  # Environment-specific direct upload url verifier screens for malicious posted upload locations.
  S3_URL_FORMAT = %r{\Ahttps:\/\/s3\.amazonaws\.com\/cubbyhole\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  belongs_to :folder
  belongs_to :user

  mount_uploader :asset, AssetUploader

  validates :name, presence: true, uniqueness: { scope: :folder_id, case_sensitive: false }
  validates :key, presence: true, format: { with: S3_URL_FORMAT }
  validates :size, presence: true
  validates :content_type, presence: true
  validates :etag, presence: true

  default_scope { where(processed: true).order('name ASC') }
  scope :roots, -> { where(folder_id: nil) }

  before_validation :set_asset_metadata, on: :create
  after_create :enqueue_processing

  def url
    asset.authenticated_url
  end

  def copy(target_folder)
    new_file = self.dup
    new_file.folder = target_folder
    new_file.save!
    new_file
  end

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def key=(url)
    write_attribute(:key, (CGI.unescape(url) rescue nil))
  end

  # Set asset metadata from the direct upload key
  def set_asset_metadata
    headers = fog_connection.head_object(CarrierWave::Uploader::Base.fog_directory, upload_data[:path]).headers

    self.name = upload_data[:filename]
    self.size = headers['Content-Length']
    self.etag = headers['Etag']
    self.content_type = headers['Content-Type']
  end

  def enqueue_processing
    worker = is_image? ? ImageWorker : AssetWorker
    worker.perform_async(id)
  end

  def is_image?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(content_type).present?
  end

  def upload_data
    S3_URL_FORMAT.match(key)
  end

  def fog_connection
    asset.class.storage.new(asset).connection
  end
end
