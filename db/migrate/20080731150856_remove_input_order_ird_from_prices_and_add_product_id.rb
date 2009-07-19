class RemoveInputOrderIrdFromPricesAndAddProductId < ActiveRecord::Migration
  def self.up
    remove_column :prices, :input_order_id
    add_column :prices, :product_detail_id, :integer
  end

  def self.down
    remove_column :prices, :product_detail_id
    add_column :prices, :input_order_id, :integer, :limit => 11
  end
end
