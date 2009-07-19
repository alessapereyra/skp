# == Schema Information
# Schema version: 20081204141634
#
# Table name: prices
#
#  id                    :integer(4)      not null, primary key
#  amount                :decimal(10, 2)
#  description           :text
#  discount              :integer(8)
#  created_at            :datetime
#  updated_at            :datetime
#  product_id            :integer(8)
#  input_order_detail_id :integer(8)
#

class Price < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :input_order_detail, :counter_cache => true
  validates_numericality_of :amount, :on => :create, :message => "debe ser un número"
  validates_numericality_of :discount, :on => :create, :message => "debe ser un número"
  
end
