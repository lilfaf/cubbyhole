class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [mounted_as, version_name, "default.png"].compact.join('_'))
  end

  version :small do
    process resize_to_fill: [80, 80]
  end

  version :thumb, from_version: :small do
    process resize_to_fill: [30, 30]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
