class AddVersionedFields < ActiveRecord::Migration
  def self.up
    QuoteDetail.create_versioned_table
    AgeRange.create_versioned_table
  end

  def self.down
    QuoteDetail.drop_versioned_table
    AgeRange.drop_versioned_table
  end
end
