class AddBuyingDateToInputOrderAndRemoveItFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :buying_date
    add_column :input_orders, :buying_date, :date
  end

  def self.down
    add_column :products, :buying_date, :date
    remove_column :input_orders, :buying_date
  end
end
