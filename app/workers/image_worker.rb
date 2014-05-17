class ImageWorker
  include Sidekiq::Worker

  def perform(id)
    asset = Asset.unscoped.includes(:user).find(id)
    asset.remote_asset_url = asset.key
    asset.save!
    asset.update_column(:processed, true)

    asset.fog_connection.delete_object(CarrierWave::Uploader::Base.fog_directory, asset.upload_data[:path])

    # Send message to the uploader with the processed image data
    WebsocketRails[asset.user.username.to_sym].trigger(:picture_processed, { id: asset.id, url: asset.asset.thumb.url })
  end
end
