class AddClientTypeToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :client_type, :string
  end

  def self.down
    remove_column :clients, :client_type
  end
end
