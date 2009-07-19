class RenameProductDetailIdFromPrices < ActiveRecord::Migration
  def self.up
    rename_column :prices, :product_detail_id, :product_id
  end

  def self.down
    rename_column :prices, :product_id, :product_detail_id
  end
end
