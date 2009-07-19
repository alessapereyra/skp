class AddOrdersGeneratedToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :orders_generated, :boolean
  end

  def self.down
    remove_column :quotes, :orders_generated
  end
end
