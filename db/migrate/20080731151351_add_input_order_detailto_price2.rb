class AddInputOrderDetailtoPrice2 < ActiveRecord::Migration
  def self.up
    add_column :prices, :input_order_detail, :integer
  end

  def self.down
    remove_column :prices, :input_order_detail
  end
end
