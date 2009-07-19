class AddDocumentToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :document, :string
  end

  def self.down
    remove_column :quotes, :document
  end
end
