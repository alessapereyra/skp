class AddPendingToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :pending, :integer
    add_column :quote_detail_versions, :pending, :integer
  end

  def self.down
    remove_column :quote_detail_versions, :pending
    remove_column :quote_details, :pending
  end
end
