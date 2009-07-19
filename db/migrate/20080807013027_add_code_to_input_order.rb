class AddCodeToInputOrder < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :code, :string
  end

  def self.down
    remove_column :input_orders, :code
  end
end
