class AddSexToQuoteDetail < ActiveRecord::Migration
  def self.up
    add_column :quote_details, :sex, :string
    add_column :quote_detail_versions, :sex, :string
  end

  def self.down
    remove_column :quote_detail_versions, :sex
    remove_column :quote_details, :sex
  end
end
