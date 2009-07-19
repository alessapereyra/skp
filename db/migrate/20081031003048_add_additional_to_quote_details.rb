class AddAdditionalToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :additional, :boolean
    add_column :quote_detail_versions, :additional, :boolean
  end

  def self.down
    remove_column :quote_detail_versions, :additional
    remove_column :quote_details, :additional
  end
end
