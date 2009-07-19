class AddAddressToExitOrders < ActiveRecord::Migration
  def self.up
    add_column :exit_orders, :address, :string
  end

  def self.down
    remove_column :exit_orders, :address
  end
end
