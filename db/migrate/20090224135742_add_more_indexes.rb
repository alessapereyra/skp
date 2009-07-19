class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :categories, :name
    add_index :brands, :name
  end

  def self.down
    remove_index :categories, :name
    remove_index :brands, :name
  end
end
