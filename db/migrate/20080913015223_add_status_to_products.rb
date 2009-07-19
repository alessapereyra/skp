class AddStatusToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :status, :string
  end

  def self.down
    remove_column :products, :status
  end
end
