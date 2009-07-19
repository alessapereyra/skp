class AddDeltaToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :delta, :boolean, :default => 0
  end

  def self.down
    remove_column :products, :delta
  end
end
