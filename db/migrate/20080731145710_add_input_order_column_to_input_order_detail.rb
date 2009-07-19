class AddInputOrderColumnToInputOrderDetail < ActiveRecord::Migration
  def self.up
    add_column :input_order_details, :input_order_id, :integer
  end

  def self.down
    remove_column :input_order_details, :input_order_id
  end
end
