class AddUnloadStockToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :unload_stock, :boolean
  end

  def self.down
    remove_column :orders, :unload_stock
  end
end
