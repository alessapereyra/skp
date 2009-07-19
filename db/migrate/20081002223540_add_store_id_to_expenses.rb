class AddStoreIdToExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :store_id, :integer
  end

  def self.down
    remove_column :expenses, :store_id
  end
end
