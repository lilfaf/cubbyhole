class CreateFileItems < ActiveRecord::Migration
  def change
    create_table :file_items do |t|
      t.string :name
      t.string :href
      t.integer :folder_id

      t.timestamps
    end

    add_index :file_items, [:name, :folder_id]
  end
end
