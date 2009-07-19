class RemoveProductIdQuantityFromInputOrders < ActiveRecord::Migration
  def self.up
    remove_column :input_orders, :product_id
    remove_column :input_orders, :quantity
  end

  def self.down
    add_column :input_orders, :quantity, :integer,    :limit => 11
    add_column :input_orders, :product_id, :integer,  :limit => 11
  end
end
