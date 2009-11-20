# == Schema Information
#
# Table name: send_order_details
#
#  id               :integer(4)      not null, primary key
#  product_id       :integer(8)
#  send_order_id    :integer(8)
#  quantity         :decimal(10, 2)
#  description      :text
#  created_at       :datetime
#  updated_at       :datetime
#  updated_quantity :integer(8)
#

class SendOrderDetail < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :send_order, :counter_cache => true
  
  validates_associated :product
  validates_associated :send_order
  
  validates_numericality_of :product_id
  validates_numericality_of :quantity, :on => :create, :message => "no es un número"

  named_scope :pending, :joins=>:send_order, :conditions=>["send_orders.status like ?", "pending"]
  named_scope :accepted, :joins=>:send_order, :conditions=>["send_orders.status like ?	" ,"accepted"]
	named_scope :for_store, lambda{|store_id| {:conditions=>["send_orders.store_id like ?",store_id]}}
	named_scope :from_store, lambda{|store_id| {:conditions=>["send_orders.owner_id like ?",store_id]}}
	named_scope :period, lambda { |period| { :joins=>:send_order, :conditions=>["send_orders.send_date >= ? and send_orders.send_date < ? ",period[:from], period[:to]] } }

  def corporative_subtotal
    unless self.product.corporative_price.blank?
      
      self.product.corporative_price * self.quantity
    
    else
      0.0
    end
  end

   
  def current_quantity
    
    updated_quantity ? updated_quantity : quantity
    
  end
  
  
  
end
