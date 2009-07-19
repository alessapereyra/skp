class AddDocumentToInputOrders < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :document, :string
  end

  def self.down
    remove_column :input_orders, :document
  end
end
