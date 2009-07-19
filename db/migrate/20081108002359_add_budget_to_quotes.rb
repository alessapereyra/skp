class AddBudgetToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :budget, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :quotes, :budget
  end
end
