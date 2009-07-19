class AddToSendingGuides < ActiveRecord::Migration
  def self.up
    add_column :sending_guides, :delivery_address, :string
    add_column :sending_guides, :delivery_contact, :string
    add_column :sending_guides, :delivery_phone, :string
  end

  def self.down
    remove_column :sending_guides, :delivery_phone
    remove_column :sending_guides, :delivery_contact
    remove_column :sending_guides, :delivery_address
  end
end
