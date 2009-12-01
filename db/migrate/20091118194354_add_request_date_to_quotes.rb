class AddRequestDateToQuotes < ActiveRecord::Migration
  def self.up
    # add_column :quotes, :request_date, :date
  end

  def self.down
    remove_column :quotes, :request_date
  end
end
