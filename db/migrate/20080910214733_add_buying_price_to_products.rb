class AddBuyingPriceToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :buying_price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :buying_price
  end
end
