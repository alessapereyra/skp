class AddInputTypeToInputOrders < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :input_type, :string
  end

  def self.down
    remove_column :input_orders, :input_type
  end
end
