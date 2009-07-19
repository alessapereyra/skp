class AddStatusToInputOrder < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :status, :string
  end

  def self.down
    remove_column :input_orders, :status
  end
end
