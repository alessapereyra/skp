class AddToToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :to, :integer
  end

  def self.down
    remove_column :products, :to
  end
end
