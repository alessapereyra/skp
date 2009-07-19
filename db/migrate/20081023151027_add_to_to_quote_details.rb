class AddToToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :to, :integer
  end

  def self.down
    remove_column :quote_details, :to
  end
end
