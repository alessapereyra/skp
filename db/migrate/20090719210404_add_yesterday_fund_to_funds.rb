class AddYesterdayFundToFunds < ActiveRecord::Migration
  def self.up
    add_column :funds, :yesterday_fund, :integer
  end

  def self.down
    remove_column :funds, :yesterday_fund
  end
end
