class AddQuoteIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :quote_id, :boolean
  end

  def self.down
    remove_column :orders, :quote_id
  end
end
