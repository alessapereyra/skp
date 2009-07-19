class AddStocksToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :stock_trigal, :decimal, :precision => 10, :scale => 2
    add_column :products, :stock_polo, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :stock_polo
    remove_column :products, :stock_trigal
  end
end
