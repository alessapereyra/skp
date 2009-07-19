class AddToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :stock_almacen, :decimal, :precision => 10, :scale => 2
    add_column :products, :stock_clarisa, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :stock_clarisa
    remove_column :products, :stock_almacen
  end
end
