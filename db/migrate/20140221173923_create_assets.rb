class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.integer :folder_id
      t.integer :user_id
      t.string :asset
      t.string :key
      t.float :size
      t.string :content_type
      t.string :etag
      t.boolean :processed, null: false, default: 0

      t.timestamps
    end

    add_index :assets, :name
    add_index :assets, :folder_id
    add_index :assets, :user_id
    add_index :assets, [:user_id, :processed]
  end
end
