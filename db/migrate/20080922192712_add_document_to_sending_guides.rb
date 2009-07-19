class AddDocumentToSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :document, :string
  end

  def self.down
    remove_column :sending_guides, :document
  end
end
