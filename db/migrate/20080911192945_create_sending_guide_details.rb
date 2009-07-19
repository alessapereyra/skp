class CreateSendingGuideDetails < ActiveRecord::Migration
  def self.up
    create_table :sending_guide_details do |t|
      t.integer :sending_guide_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end

  def self.down
    drop_table :sending_guide_details
  end
end
