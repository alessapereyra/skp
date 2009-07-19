class RenameCreditCartToCreditCardToOrders < ActiveRecord::Migration
  def self.up
    rename_column :orders, :credit_cart, :credit_card
  end

  def self.down
    rename_column :orders, :credit_card, :credit_cart
  end
end
