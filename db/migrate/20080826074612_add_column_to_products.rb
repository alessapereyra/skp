class AddColumnToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :picture, :string
  end

  def self.down
    remove_column :products, :picture
  end
end
