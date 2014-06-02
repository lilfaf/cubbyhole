class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :body
      t.integer :share_link_id

      t.timestamps
    end
  end
end
