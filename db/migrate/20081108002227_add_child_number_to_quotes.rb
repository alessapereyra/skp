class AddChildNumberToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :child_number, :integer
  end

  def self.down
    remove_column :quotes, :child_number
  end
end
