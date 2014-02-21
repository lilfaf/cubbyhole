class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name, null: false
      t.string :type
      t.string :href
      t.string :ancestry
      t.integer :user_id

      t.timestamps
    end
    add_index :entries, :ancestry, unique: true
    add_index :entries, :user_id
  end
end
