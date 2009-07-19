class AddPriceToExitOrders < ActiveRecord::Migration
  def self.up
    add_column :exit_orders, :price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :exit_orders, :price
  end
end
