class CreateSendingGuides < ActiveRecord::Migration
  def self.up
    create_table :sending_guides do |t|
      t.integer :store_id
      t.integer :client_id
      t.datetime :sending_date
      t.string :driver_name
      t.string :license_plate
      t.string :truck_description

      t.timestamps
    end
  end

  def self.down
    drop_table :sending_guides
  end
end
