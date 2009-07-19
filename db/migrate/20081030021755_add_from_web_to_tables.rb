class AddFromWebToTables < ActiveRecord::Migration
  def self.up
    add_column :age_range_versions, :from_web, :boolean
    add_column :quote_detail_versions, :from_web, :boolean
  end

  def self.down
    remove_column :quote_detail_versions, :from_web
    remove_column :age_range_versions, :from_web
  end
end
