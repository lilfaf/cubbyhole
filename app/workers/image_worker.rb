class ImageWorker
  include Sidekiq::Worker

  def perform(id)
    asset = Asset.find(id)
    asset.remote_asset_url = asset.key
    asset.save!
    asset.update_column(:processed, true)

    asset.fog_connection.delete_object(CarrierWave::Uploader::Base.fog_directory, asset.upload_data[:path])
  end
end
