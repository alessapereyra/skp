class CreateExitOrders < ActiveRecord::Migration
  def self.up
    create_table :exit_orders do |t|
      t.integer :store_id
      t.integer :client_id
      t.datetime :sending_date
      t.string :driver_name
      t.string :driver_dni
      t.text :extra_data
      t.datetime :created_at
      t.datetime :updated_at
      t.string :status
      t.string :document
      t.boolean :unload_stock

      t.timestamps
    end
  end

  def self.down
    drop_table :exit_orders
  end
end
