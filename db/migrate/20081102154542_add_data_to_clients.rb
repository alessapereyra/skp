class AddDataToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :legal_representative, :string
    add_column :clients, :contact_person, :string
    add_column :clients, :contact_email, :string
  end

  def self.down
    remove_column :clients, :contact_email
    remove_column :clients, :contact_person
    remove_column :clients, :legal_representative
  end
end
