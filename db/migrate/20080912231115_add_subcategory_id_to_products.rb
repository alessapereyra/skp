class AddSubcategoryIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :subcategory_id, :integer
  end

  def self.down
    remove_column :products, :subcategory_id
  end
end
