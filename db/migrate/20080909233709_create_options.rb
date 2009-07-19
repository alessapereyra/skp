class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :current_store
      t.float :igv

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
