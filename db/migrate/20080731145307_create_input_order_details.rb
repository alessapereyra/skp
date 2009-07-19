class CreateInputOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :input_order_details do |t|
      t.integer :quantity
      t.decimal :price, :precision=>10, :scale=>2
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :input_order_details
  end
end
