class CreateSendOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :send_order_details do |t|
      t.integer :product_id
      t.integer :send_order_id      
      t.integer :quantity
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :send_order_details
  end
end
