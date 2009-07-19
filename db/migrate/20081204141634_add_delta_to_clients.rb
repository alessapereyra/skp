class AddDeltaToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :delta, :boolean, :default => 0
  end

  def self.down
    remove_column :clients, :delta
  end
end
