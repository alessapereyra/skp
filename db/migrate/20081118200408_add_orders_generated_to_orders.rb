class AddOrdersGeneratedToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :orders_generated, :integer
  end

  def self.down
    remove_column :orders, :orders_generated
  end
end
