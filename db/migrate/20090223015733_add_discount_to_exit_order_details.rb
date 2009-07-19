class AddDiscountToExitOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :exit_order_details, :discount, :integer
  end

  def self.down
    remove_column :exit_order_details, :discount
  end
end
