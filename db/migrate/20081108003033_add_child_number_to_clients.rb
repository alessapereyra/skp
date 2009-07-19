class AddChildNumberToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :child_number, :integer
  end

  def self.down
    remove_column :clients, :child_number
  end
end
