class AddIsRequestedToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :is_requested, :boolean
  end

  def self.down
    remove_column :quotes, :is_requested
  end
end
