class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.float :price
      t.integer :max_storage_space
      t.integer :max_bandwidth_up
      t.integer :max_bandwidth_down
      t.integer :daily_shared_links_quota

      t.timestamps
    end

    add_index :plans, :name, unique: true
  end
end
