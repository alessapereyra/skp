class AddWarehousePlaceToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :warehouse_place, :string
  end

  def self.down
    remove_column :products, :warehouse_place
  end
end
