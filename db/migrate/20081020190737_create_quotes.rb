class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.integer :client_id
      t.integer :store_id
      t.integer :user_id
      t.string :client_address
      t.datetime :quote_date
      t.integer :duration
      t.string :sending_details
      t.text :quote_comments

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
