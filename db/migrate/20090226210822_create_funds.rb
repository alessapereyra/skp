class CreateFunds < ActiveRecord::Migration
  def self.up
    create_table :funds do |t|
      t.integer :store_id
      t.datetime :registry_date
      t.decimal :net_income, :decimal, :precision => 10, :scale => 2
      t.decimal :widthdrawal, :decimal, :precision => 10, :scale => 2
      t.decimal :cash_amount, :decimal, :precision => 10, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :funds
  end
end
