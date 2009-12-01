class AddQuoteIdToSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :quote_id, :integer
  end

  def self.down
    remove_column :sending_guides, :quote_id
  end
end
