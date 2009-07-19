class AddStatusInputOrder < ActiveRecord::Migration
  def self.up
    rename_column :input_order_details, :price, :cost
  end

  def self.down
    rename_column :input_order_details, :cost, :price
  end
end
