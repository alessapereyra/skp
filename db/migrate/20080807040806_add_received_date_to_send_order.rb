class AddReceivedDateToSendOrder < ActiveRecord::Migration
  def self.up
    add_column :send_orders, :received_date, :datetime
  end

  def self.down
    remove_column :send_orders, :received_date
  end
end
