class AddSendingTypeToSendingGuide < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :sending_type, :string
  end

  def self.down
    remove_column :sending_guides, :sending_type
  end
end
