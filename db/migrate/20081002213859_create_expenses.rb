class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :description
      t.datetime :expense_date

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
