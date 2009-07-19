class AddPrices2CountToInputOrderDetails < ActiveRecord::Migration
  def self.up
    remove_column :input_order_details, :prices_count
    add_column :input_order_details, :prices_count, :integer, :default=>0
  end

  def self.down
    add_column :input_order_details, :prices_count, :integer
    remove_column :input_order_details, :prices_count
  end
end
