class AddAdditionalCodeToInputOrderDetail < ActiveRecord::Migration
  def self.up
    add_column :input_order_details, :additional_code, :string
  end

  def self.down
    remove_column :input_order_details, :additional_code
  end
end
