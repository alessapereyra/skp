class AddDeliveryDateToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :delivered_date, :datetime
  end

  def self.down
    remove_column :quotes, :delivered_date
  end
end
