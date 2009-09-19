# == Schema Information
# Schema version: 20090320214122
#
# Table name: order_details
#
#  id                      :integer(4)      not null, primary key
#  product_id              :integer(8)
#  order_id                :integer(8)
#  price                   :decimal(10, 2)
#  quantity                :decimal(10, 2)
#  discount                :integer(8)
#  created_at              :datetime
#  updated_at              :datetime
#  sending_guide_detail_id :integer(4)
#  pending                 :integer(4)
#

class OrderDetail < ActiveRecord::Base
  
  belongs_to :order, :counter_cache => true
  belongs_to :client
  belongs_to :product
  belongs_to :sending_guide_detail
  
  validates_numericality_of :quantity, :allow_nil=>true
  validates_numericality_of :price, :allow_nil=>true
  validates_numericality_of :discount, :allow_nil=>true
  
  validates_presence_of :product_id
  validates_presence_of :price
  validates_presence_of :quantity

  validates_associated :product
  validates_associated :order
  
  def subtotal
    discount.nil? || discount.zero? ? price*quantity  : (price*(1.00-discount/100.00))*quantity
  end
  
  def convert(quote_detail)
    unless quote_detail.nil?
      self.product_id = quote_detail.product_id
      self.quantity = quote_detail.quantity
      self.price = quote_detail.price.to_f
      self.save
    end
    
  end
  
end
