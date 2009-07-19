class AddUnloadStockToInputOrders < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :unload_stock, :boolean
  end

  def self.down
    remove_column :input_orders, :unload_stock
  end
end
