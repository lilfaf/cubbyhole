object @item
attributes :id, :name

node(:type) { |i| i.is_a?(Folder) ? 'folder' : 'file' }
