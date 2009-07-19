class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.decimal :amount, :precision=>10, :scale=>2
      t.text :description
      t.integer :discount

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
