class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.string :ancestry
      t.integer :user_id

      t.timestamps
    end

    add_index :folders, :ancestry, unique: true
    add_index :folders, :user_id
  end
end
