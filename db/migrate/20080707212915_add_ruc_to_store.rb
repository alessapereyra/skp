class AddRucToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :ruc, :string
  end

  def self.down
    remove_column :stores, :ruc
  end
end
