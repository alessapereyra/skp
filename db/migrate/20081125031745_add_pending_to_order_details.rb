class AddPendingToOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :order_details, :pending, :integer
  end

  def self.down
    remove_column :order_details, :pending
  end
end
