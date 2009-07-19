class AddPackNumberToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :pack_number, :integer
    add_column :quote_detail_versions, :pack_number, :integer
  end

  def self.down
    remove_column :quote_detail_versions, :pack_number
    remove_column :quote_details, :pack_number
  end
end
