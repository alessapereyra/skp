class AddQuoteDetailsCountToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :quote_details_count, :integer
  end

  def self.down
    remove_column :quotes, :quote_details_count
  end
end
