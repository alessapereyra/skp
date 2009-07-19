class AddUnloadStockSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :unload_stock, :boolean
  end

  def self.down
    remove_column :sending_guides, :unload_stock
  end
end
