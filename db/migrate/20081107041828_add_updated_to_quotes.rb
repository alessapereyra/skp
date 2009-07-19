class AddUpdatedToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :updated, :boolean
  end

  def self.down
    remove_column :quotes, :updated
  end
end
