class AddSendingGuidesGenerated < ActiveRecord::Migration
  def self.up
    add_column :quotes, :sending_guides_generated, :boolean
  end

  def self.down
    remove_column :quotes, :sending_guides_generated
  end
end
