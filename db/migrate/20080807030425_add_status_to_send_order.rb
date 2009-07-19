class AddStatusToSendOrder < ActiveRecord::Migration
  def self.up
    add_column :send_orders, :status, :string
  end

  def self.down
    remove_column :send_orders, :status
  end
end
