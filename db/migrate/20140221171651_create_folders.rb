class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :user_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end

    add_index :folders, :user_id
    add_index :folders, :parent_id
    add_index :folders, :lft
    add_index :folders, :rgt
    add_index :folders, :depth
    add_index :folders, [:name, :parent_id]
  end
end
