class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :size, :content_type, :etag, :url, :created_at, :updated_at

  def url
    object.key
  end

  def type
    'file'
  end
end
