# == Schema Information
# Schema version: 20090220010446
#
# Table name: stores
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  address               :string(255)
#  description           :string(255)
#  telephone             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  ruc                   :string(255)
#  cash_amount           :decimal(10, 2)
#  yesterday_cash_amount :decimal(10, 2)
#

class Store < ActiveRecord::Base
  
  validates_presence_of :name, :on => :create, :message => " no puede estar vacío"
  
  has_many :input_orders
  has_many :input_order_details, :through => :input_orders
  has_many :orders
  has_many :send_orders
  has_many :sending_guides
  has_many :owned_send_orders, :class_name => "SendOrder", :foreign_key => "owner_id"
  has_many :quotes
  has_many :providers, :through=>:input_orders
  has_many :exit_orders
  has_many :funds
  
  has_many :products, :through => :input_orders
#  has_many :products, :through =>:input_orders #terminar la condición
end
