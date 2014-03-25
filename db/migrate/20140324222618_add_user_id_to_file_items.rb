class AddUserIdToFileItems < ActiveRecord::Migration
  def change
    add_column :file_items, :user_id, :string
    add_index :file_items, :user_id
  end
end
