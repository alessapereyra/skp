class AddUpdatedQuantityToSendOrderDetail < ActiveRecord::Migration
  def self.up
    add_column :send_order_details, :updated_quantity, :integer
  end

  def self.down
    remove_column :send_order_details, :updated_quantity
  end
end
