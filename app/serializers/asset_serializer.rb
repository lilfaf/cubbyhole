class AssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :size, :content_type, :etag, :url, :created_at, :updated_at

  def url
    object.key
  end
end
