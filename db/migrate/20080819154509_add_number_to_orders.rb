class AddNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :number, :integer
  end

  def self.down
    remove_column :orders, :number

  end
end
