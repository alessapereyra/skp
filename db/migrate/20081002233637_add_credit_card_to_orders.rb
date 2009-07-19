class AddCreditCardToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :credit_cart, :string
  end

  def self.down
    remove_column :orders, :credit_cart
  end
end
