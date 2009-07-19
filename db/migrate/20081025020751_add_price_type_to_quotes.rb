class AddPriceTypeToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :price_type, :string
  end

  def self.down
    remove_column :quotes, :price_type
  end
end
