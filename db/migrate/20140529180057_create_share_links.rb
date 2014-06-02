class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
      t.string :token
      t.datetime :expires_at
      t.integer :asset_id
      t.integer :sender_id

      t.timestamps
    end
  end
end
