# == Schema Information
# Schema version: 20081204141634
#
# Table name: providers
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  address        :string(255)
#  telephone      :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  ruc            :string(255)
#  contact_person :string(255)
#

class Provider < ActiveRecord::Base
  
  has_many :input_orders
  has_many :products, :through => :input_orders
  has_many :stores, :through => :input_orders
  
  validates_presence_of :name, :on => :create, :message => "no puede estar vacío"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message => "is invalid"
  
end
