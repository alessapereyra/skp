class AddAgeToToQuoteDetails < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :age_to, :integer
  end

  def self.down
    remove_column :quote_details, :age_to
  end
end
