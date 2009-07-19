class CreateSendOrders < ActiveRecord::Migration
  def self.up
    create_table :send_orders do |t|
      t.integer :owner_id
      t.integer :store_id
      t.datetime :send_date
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :send_orders
  end
end
