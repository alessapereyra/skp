class AddIndexesToUsers < ActiveRecord::Migration
  def self.up
        add_index :users, :username
        add_index :exit_order_details, :exit_order_id
  end

  def self.down
        remove_index :users, :username
        remove_index :exit_order_details, :exit_order_id
  end
end
