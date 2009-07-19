class AddPrintDescriptionToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :print_description, :boolean
  end

  def self.down
    remove_column :products, :print_description
  end
end
