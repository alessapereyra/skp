class AddFromToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :from, :integer
  end

  def self.down
    remove_column :products, :from
  end
end
