# == Schema Information
#
# Table name: clients
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  address              :string(255)
#  telephone            :string(255)
#  dni                  :string(255)
#  ruc                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  legal_representative :string(255)
#  contact_person       :string(255)
#  contact_email        :string(255)
#  budget               :decimal(10, 2)
#  child_number         :integer(4)
#  delta                :boolean(1)
#  client_type          :string(255)
#

#require 'acts_as_ferret'

class Client < ActiveRecord::Base

  #acts_as_ferret :fields=>[:name, :address, :telephone, :dni, :ruc,:legal_representative,:contact_person,:contact_email]
    
  has_many :orders
  has_many :exit_orders
  
	ClientTypes = [
									"",
									"mayorista",
									"distribuidor",
									"corporativo",
									"web"
								]

  define_index do
      # fields
      indexes :name, :sortable => true
      indexes address
      indexes telephone
      indexes dni
      indexes ruc
      indexes legal_representative
      indexes contact_person
      indexes contact_email      
      set_property :delta => true
      set_property :enable_star => true
      set_property :min_infix_len => 3    
  end
  
  def self.buyers
    
    Client.all.select {|c| not c.exit_orders.empty? }
    
  end
  
end

