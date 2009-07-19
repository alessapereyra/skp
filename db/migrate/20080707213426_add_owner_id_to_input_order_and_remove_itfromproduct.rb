class AddOwnerIdToInputOrderAndRemoveItfromproduct < ActiveRecord::Migration
  def self.up
    remove_column :products, :owner_id
    add_column :input_orders, :owner_id, :integer
  end

  def self.down
    remove_column :input_orders, :owner_id
    add_column :products, :owner_id, :integer, :limit => 11
  end
end
