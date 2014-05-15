class AssetWorker
  include Sidekiq::Worker

  def perform(id)
    asset = Asset.find(id)

    asset.fog_connection.copy_object(
      bucket, asset.upload_data[:path],
      bucket, "#{asset.asset.store_dir}/#{asset.upload_data[:filename]}"
    )
    asset.fog_connection.delete_object(bucket, asset.upload_data[:path])
  end

  def bucket
    CarrierWave::Uploader::Base.fog_directory
  end
end
