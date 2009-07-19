class AddPendingToSendingGuideDetails < ActiveRecord::Migration
  def self.up
    add_column :sending_guide_details, :pending, :integer
  end

  def self.down
    remove_column :sending_guide_details, :pending
  end
end
