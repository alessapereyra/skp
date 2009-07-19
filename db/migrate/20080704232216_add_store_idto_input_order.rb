class AddStoreIdtoInputOrder < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :store_id, :integer
  end

  def self.down
    remove_column :input_orders, :store_id
  end
end
