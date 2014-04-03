class AddAssetAttachmentToFileItems < ActiveRecord::Migration
  def change
    add_column :file_items, :asset, :string
    add_column :file_items, :key, :string
    add_column :file_items, :size, :float
    add_column :file_items, :content_type, :string
    add_column :file_items, :etag, :string
    add_column :file_items, :processed, :boolean, { default: false, null: false }
    add_index :file_items, [:user_id, :processed]
  end
end
