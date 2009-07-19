class AddStocksToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :stock_from_almacen, :integer
    add_column :quote_details, :stock_from_carisa, :integer
    add_column :quote_details, :stock_from_trigal, :integer
    add_column :quote_details, :stock_from_polo, :integer
    add_column :quote_detail_versions, :stock_from_almacen, :integer
    add_column :quote_detail_versions, :stock_from_carisa, :integer
    add_column :quote_detail_versions, :stock_from_trigal, :integer
    add_column :quote_detail_versions, :stock_from_polo, :integer


  end

  def self.down
    remove_column :quote_details, :stock_from_polo
    remove_column :quote_details, :stock_from_trigal
    remove_column :quote_details, :stock_from_carisa
    remove_column :quote_details, :stock_from_almacen
    remove_column :quote_detail_versions, :stock_from_polo
    remove_column :quote_detail_versions, :stock_from_trigal
    remove_column :quote_detail_versions, :stock_from_carisa
    remove_column :quote_detail_versions, :stock_from_almacen

  end
end
