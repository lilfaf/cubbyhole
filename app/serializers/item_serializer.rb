class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :type

  def type
    object.is_a?(Folder) ? 'folder' : 'file'
  end
end
