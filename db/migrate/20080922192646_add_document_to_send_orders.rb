class AddDocumentToSendOrders < ActiveRecord::Migration
  def self.up
    add_column :send_orders, :document, :string
  end

  def self.down
    remove_column :send_orders, :document
  end
end
