class ChangePriceFromQuoteDetails < ActiveRecord::Migration
  def self.up
    remove_column :quote_details, :price
    add_column :quote_details, :price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :quote_details, :price
    add_column :quote_details, :price, :decimal, :precision => 10, :scale => 2
  end
end
