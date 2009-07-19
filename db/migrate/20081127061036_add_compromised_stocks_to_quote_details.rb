class AddCompromisedStocksToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_detail_versions, :stock_trigal_compromised, :integer, :default => 0
    add_column :quote_detail_versions, :stock_polo_compromised, :integer, :default => 0
    add_column :quote_detail_versions, :stock_almacen_compromised, :integer, :default=>0
    add_column :quote_detail_versions, :stock_carisa_compromised, :integer, :default=>0    

  end

  def self.down
    remove_column :quote_detail_versions, :stock_carisa_compromised
    remove_column :quote_detail_versions, :stock_almacen_compromised
    remove_column :quote_detail_versions, :stock_polo_compromised
    remove_column :quote_detail_versions, :stock_trigal_compromised

  end
end
