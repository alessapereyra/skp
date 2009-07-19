class CreateQuoteDetails < ActiveRecord::Migration
  def self.up
    create_table :quote_details do |t|
      t.integer :quote_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price, :precision => 10, :scale => 2
      t.string :product_detail

      t.timestamps
    end
  end

  def self.down
    drop_table :quote_details
  end
end
