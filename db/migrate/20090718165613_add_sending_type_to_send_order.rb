class AddSendingTypeToSendOrder < ActiveRecord::Migration
  def self.up
    add_column :send_orders, :sending_type, :string
  end

  def self.down
    remove_column :send_orders, :sending_type
  end
end
