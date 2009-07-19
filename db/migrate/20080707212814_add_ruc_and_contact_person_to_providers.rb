class AddRucAndContactPersonToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :ruc, :string
    add_column :providers, :contact_person, :string
  end

  def self.down
    remove_column :providers, :contact_person
    remove_column :providers, :ruc
  end
end
