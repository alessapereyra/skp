class RemoveAndRecreateAddStuff < ActiveRecord::Migration
  def self.up
    remove_column :exit_order_details, :quantity
    add_column :exit_order_details, :quantity, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :exit_order_details, :quantity
    add_column :exit_order_details, :quantity, :integer
  end
end
