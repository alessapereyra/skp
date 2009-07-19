class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :description
      t.string :telephone

      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
