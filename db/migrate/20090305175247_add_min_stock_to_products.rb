class AddMinStockToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :min_stock, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :min_stock
  end
end
