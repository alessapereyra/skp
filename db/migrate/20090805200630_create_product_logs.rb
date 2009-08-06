class CreateProductLogs < ActiveRecord::Migration
  def self.up
    create_table :product_logs do |t|
      t.integer :product_logs_id
      t.integer :product_id
      t.string :controller
      t.string :method
      t.decimal :last_stock, :precision => 10, :scale => 2
      t.decimal :last_stock_trigal, :precision => 10, :scale => 2
      t.decimal :last_stock_polo, :precision => 10, :scale => 2
      t.decimal :last_stock_almacen, :precision => 10, :scale => 2
      t.decimal :last_stock_clarisa, :precision => 10, :scale => 2
      t.decimal :stock, :precision => 10, :scale => 2
      t.decimal :stock_trigal, :precision => 10, :scale => 2
      t.decimal :stock_polo, :precision => 10, :scale => 2
      t.decimal :stock_almacen, :precision => 10, :scale => 2
      t.decimal :stock_clarisa, :precision => 10, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :product_logs
  end
end
