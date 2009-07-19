class AddBudgetToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :budget, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :clients, :budget
  end
end
