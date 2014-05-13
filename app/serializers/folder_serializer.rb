class FolderSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :created_at, :updated_at

  def type
    'folder'
  end
end
