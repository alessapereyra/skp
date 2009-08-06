class AddForImportToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :for_import, :boolean
  end

  def self.down
    remove_column :products, :for_import
  end
end
