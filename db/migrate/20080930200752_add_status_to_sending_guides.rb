class AddStatusToSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :status, :string
  end

  def self.down
    remove_column :sending_guides, :status
  end
end
