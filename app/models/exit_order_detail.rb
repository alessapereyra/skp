# == Schema Information
# Schema version: 20090223035552
#
# Table name: exit_order_details
#
#  id            :integer(4)      not null, primary key
#  exit_order_id :integer(4)
#  product_id    :integer(4)
#  price         :decimal(10, 2)
#  created_at    :datetime
#  updated_at    :datetime
#  status        :integer(4)
#  discount      :integer(4)
#  quantity      :decimal(10, 2)
#

class ExitOrderDetail < ActiveRecord::Base

  belongs_to :exit_order, :counter_cache => true
  belongs_to :product
  
  validates_presence_of :price
  validates_presence_of :quantity
	
  named_scope :pending, :joins=>:exit_order, :conditions=>["exit_orders.status like ?","pending"]
  named_scope :accepted, :joins=>:exit_order, :conditions=>["exit_orders.status like ?",'accepted']
	named_scope :of_store, lambda{|store_id| {:conditions=>["exit_orders.store_id like ?",store_id]}}
	named_scope :period, lambda { |period| { :joins=>:exit_order, :conditions=>["exit_orders.sending_date >= ? and exit_orders.sending_date < ? ",period[:from], period[:to]] } }


 def subtotal

   discount.nil? ? price*quantity : (price*(1.0-discount/100.0)) *quantity

 end

end
