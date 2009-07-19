class AddContactNameToQuotes < ActiveRecord::Migration
  def self.up
    add_column :quotes, :contact_name, :string
  end

  def self.down
    remove_column :quotes, :contact_name
  end
end
