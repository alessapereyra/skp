class CreateOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :order_details do |t|
      t.integer :product_id
      t.integer :order_id
      t.decimal :price, :precision=>10, :scale=>2
      t.integer :quantity
      t.integer :discount

      t.timestamps
    end
  end

  def self.down
    drop_table :order_details
  end
end
