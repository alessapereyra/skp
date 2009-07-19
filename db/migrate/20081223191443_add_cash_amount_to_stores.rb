class AddCashAmountToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :cash_amount, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :stores, :cash_amount
  end
end
