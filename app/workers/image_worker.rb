class ImageWorker
  include Sidekiq::Worker

  def perform(id)
    asset = Asset.unscoped.find(id)
    asset.remote_asset_url = asset.key
    asset.save!
    asset.update_column(:processed, true)

    asset.fog_connection.delete_object(CarrierWave::Uploader::Base.fog_directory, asset.upload_data[:path])

    # Send message to the clients with the processed image data
    WebsocketRails[:main_channel].trigger(:picture_processed, { id: asset.id, url: asset.asset.thumb.url })
  end
end
