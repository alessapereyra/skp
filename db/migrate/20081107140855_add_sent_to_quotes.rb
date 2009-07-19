class AddSentToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :sent, :boolean
  end

  def self.down
    remove_column :quotes, :sent
  end
end
