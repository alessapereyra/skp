class CreateExitOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :exit_order_details do |t|
      t.integer :exit_order_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price, :precision => 10, :scale => 2
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :exit_order_details
  end
end
