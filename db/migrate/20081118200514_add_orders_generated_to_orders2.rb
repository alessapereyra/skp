class AddOrdersGeneratedToOrders2 < ActiveRecord::Migration
  def self.up
    remove_column :orders, :orders_generated    
    add_column :orders, :orders_generated, :boolean
  end

  def self.down
    remove_column :orders, :orders_generated
    add_column :orders, :orders_generated, :integer
    
  end
end
