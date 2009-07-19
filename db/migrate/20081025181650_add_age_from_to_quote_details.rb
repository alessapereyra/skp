class AddAgeFromToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :age_from, :integer
  end

  def self.down
    remove_column :quote_details, :age_from
  end
end
