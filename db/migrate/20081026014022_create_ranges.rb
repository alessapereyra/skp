class CreateRanges < ActiveRecord::Migration
  def self.up
    create_table :age_ranges do |t|
      t.integer :quote_id
      t.integer :age_from
      t.integer :age_to
      t.integer :femenine
      t.integer :masculine

      t.timestamps
    end
  end

  def self.down
    drop_table :age_ranges
  end
end
