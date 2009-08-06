class AddExpensesToFunds < ActiveRecord::Migration
  def self.up
    add_column :funds, :expenses, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :funds, :expenses
  end
end
