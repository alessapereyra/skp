class CreateInputOrders < ActiveRecord::Migration
  def self.up
    create_table :input_orders do |t|
      t.integer :provider_id
      t.integer :product_id
      t.decimal :cost, :precision=>10, :scale=>2
      t.integer :quantity
      t.datetime :order_date
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :input_orders
  end
end
