class CustomArraySerializer < ActiveModel::ArraySerializer
  self.root = false

  def serializer_for(item)
    serializer_class = item.is_a?(Folder) ? FolderSerializer : AssetSerializer
    serializer_class.new(item, scope: scope)
  end
end
