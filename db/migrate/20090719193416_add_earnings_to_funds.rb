class AddEarningsToFunds < ActiveRecord::Migration
  def self.up
    add_column :funds, :earnings, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :funds, :earnings
  end
end
