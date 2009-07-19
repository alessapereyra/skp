class AddStatusToSendingGuideDetails < ActiveRecord::Migration
  def self.up
    add_column :sending_guide_details, :status, :string
    add_column :orders, :sending_guide_id, :integer
  end

  def self.down
    remove_column :orders, :sending_guide_id
    remove_column :sending_guide_details, :status
  end
end
