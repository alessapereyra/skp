class AddProviderIdToSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :provider_id, :integer
  end

  def self.down
    remove_column :sending_guides, :provider_id
  end
end
