class AddToProductsSpecialPriceAndNote < ActiveRecord::Migration
  def self.up
    add_column :products, :special_price, :decimal, :precision => 10, :scale => 2
    add_column :products, :note, :string
  end

  def self.down
    remove_column :products, :special_price
    remove_column :products, :note
  end
end
