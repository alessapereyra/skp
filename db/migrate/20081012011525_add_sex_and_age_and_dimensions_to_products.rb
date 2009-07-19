class AddSexAndAgeAndDimensionsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :age, :string
    add_column :products, :height, :decimal, :precision => 10, :scale => 2
    add_column :products, :width, :decimal, :precision => 10, :scale => 2
    add_column :products, :weight, :decimal, :precision => 10, :scale => 2
    add_column :products, :length, :decimal, :precision => 10, :scale => 2
    add_column :products, :sex, :string
  end

  def self.down
    remove_column :products, :sex
    remove_column :products, :length
    remove_column :products, :weight
    remove_column :products, :width
    remove_column :products, :height
    remove_column :products, :age
  end
end
