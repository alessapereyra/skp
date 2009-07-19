class AddSendingGuideDetailIdToOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :order_details, :sending_guide_detail_id, :integer
  end

  def self.down
    remove_column :order_details, :sending_guide_detail_id
  end
end
