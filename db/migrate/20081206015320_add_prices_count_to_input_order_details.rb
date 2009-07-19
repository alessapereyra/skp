class AddPricesCountToInputOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :input_order_details, :prices_count, :integer
  end

  def self.down
    remove_column :input_order_details, :prices_count
  end
end
