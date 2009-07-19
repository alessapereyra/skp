class AddStatusToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :status, :string
  end

  def self.down
    remove_column :quotes, :status
  end
end
