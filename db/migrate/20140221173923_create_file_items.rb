class CreateFileItems < ActiveRecord::Migration
  def change
    create_table :file_items do |t|
      t.string :name
      t.string :href
      t.integer :folder_id

      t.timestamps
    end
  end
end
