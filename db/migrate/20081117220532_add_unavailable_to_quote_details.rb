class AddUnavailableToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :unavailable, :boolean
    add_column :quote_detail_versions, :unavailable, :boolean
  end

  def self.down
    remove_column :quote_detail_versions, :unavailable
    remove_column :quote_details, :unavailable
  end
end
