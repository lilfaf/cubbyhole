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

  default_scope { where(processed: true) }
  scope :roots, -> { where(folder_id: nil) }

  before_validation :set_asset_metadata, on: :create

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

  # Determines if file requires post-processing (image resizing, etc)
  def post_processing_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(content_type).present?
  end

  # Set asset metadata from the direct upload key
  # Retry logic handles an eventual S3 lag.
  def set_asset_metadata
    tries ||= 5
    s3_url_data = S3_URL_FORMAT.match(key)
    s3 = AWS::S3.new
    headers = s3.buckets[S3DirectUpload.config.bucket].objects[s3_url_data[:path]].head

    self.name = s3_url_data[:filename]
    self.size = headers.content_length
    self.etag = headers.etag
    self.content_type = headers.content_type
  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    sleep(1) and retry if tries > 0
  end
end
