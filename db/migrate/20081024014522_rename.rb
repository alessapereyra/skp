class Rename < ActiveRecord::Migration
  def self.up
    rename_column :products, :from, :age_from
    rename_column :products, :to, :age_to
  end

  def self.down
    rename_column :products, :age_to, :to
    rename_column :products, :age_from, :from


  end
end
