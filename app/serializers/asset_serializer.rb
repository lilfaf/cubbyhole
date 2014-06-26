class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :size, :content_type, :etag, :url, :created_at, :updated_at, :key

  def url
    #raise object.inspect
    object.asset_url
  end

  def key
    object.key
  end

  def type
    'file'
  end
end
