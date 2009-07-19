class AddFromToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :from, :integer
  end

  def self.down
    remove_column :quote_details, :from
  end
end
