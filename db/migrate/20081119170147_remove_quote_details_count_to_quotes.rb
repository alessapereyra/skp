class RemoveQuoteDetailsCountToQuotes < ActiveRecord::Migration
  def self.up
    remove_column :quotes, :quote_details_count
    add_column :quotes, :quote_details_count, :integer, :default=>0
  end

  def self.down
    remove_column :quotes, :quote_details_count
    add_column :quotes, :quote_details_count, :integer
  end
end
