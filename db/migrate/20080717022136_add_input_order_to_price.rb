class AddInputOrderToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :input_order_id, :integer
  end

  def self.down
    remove_column :prices, :input_order_id
  end
end
