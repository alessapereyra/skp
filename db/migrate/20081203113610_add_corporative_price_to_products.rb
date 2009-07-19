class AddCorporativePriceToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :corporative_price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :corporative_price
  end
end
