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

  belongs_to :exit_order
  belongs_to :product
  
  validates_presence_of :price
  validates_presence_of :quantity


 def subtotal

   discount.nil? ? price*quantity : (price*(1.0-discount/100.0)) *quantity

 end

end
