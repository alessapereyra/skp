class AddSalesToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :available_sale, :boolean
    add_column :products, :sale_discount, :integer
    add_column :products, :sale_description, :string
  end

  def self.down
    remove_column :products, :sale_description
    remove_column :products, :sale_discount
    remove_column :products, :available_sale
  end
end
