class AddInputOrderDetailtoPriceRename < ActiveRecord::Migration
  def self.up
    rename_column :prices, :input_order_detail, :input_order_detail_id
  end

  def self.down
    rename_column :prices, :input_order_detail_id, :input_order_detail
  end
end
