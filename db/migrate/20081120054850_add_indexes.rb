class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :products, :code
  end

  def self.down
    remove_index :products, :code
    add
  end
end
