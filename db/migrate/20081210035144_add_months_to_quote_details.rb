class AddMonthsToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :months, :boolean
    add_column :quote_detail_versions, :months, :boolean
  end

  def self.down
    remove_column :quote_detail_versions, :months
    remove_column :quote_details, :months
  end
end
