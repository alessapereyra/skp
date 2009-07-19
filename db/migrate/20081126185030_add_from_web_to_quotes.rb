class AddFromWebToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :from_web, :boolean
  end

  def self.down
    remove_column :quotes, :from_web
  end
end
