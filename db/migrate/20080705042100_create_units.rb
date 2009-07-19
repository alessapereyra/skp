class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string :name
      t.integer :equivalent_unit_id
      t.decimal :equivalence, :scale=>3
      t.timestamps
    end
  end

  def self.down
    drop_table :units
  end
end
