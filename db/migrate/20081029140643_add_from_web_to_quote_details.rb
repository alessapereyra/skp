class AddFromWebToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :from_web, :boolean
  end

  def self.down
    remove_column :quote_details, :from_web
  end
end
