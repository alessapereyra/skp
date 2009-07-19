class AddFromWebToAgeRanges < ActiveRecord::Migration
  def self.up
    add_column :age_ranges, :from_web, :boolean
  end

  def self.down
    remove_column :age_ranges, :from_web
  end
end
