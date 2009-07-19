# == Schema Information
#
# Table name: send_orders
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(8)
#  store_id      :integer(8)
#  send_date     :datetime
#  user_id       :integer(8)
#  created_at    :datetime
#  updated_at    :datetime
#  status        :string(255)
#  received_date :datetime
#  document      :string(255)
#  sending_type  :string(255)
#

class SendOrder < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "Store", :foreign_key => "owner_id"
  belongs_to :store
  
  has_many :send_order_details
  has_many :products, :through=>:send_order_details
  
  named_scope :pending, :conditions=>{:status => "pending"}
  named_scope :accepted, :conditions=>{:status => "accepted"} 

  validates_associated :store
  validates_presence_of :owner_id, :allow_nil=>true
  
  def childless?
    self.send_order_details.empty?
  end
  
  def details_for_product(product)
    
    self.send_order_details.find(:all, :conditions=>{:product_id=>product})

    
  end
  
  def pending?
    self.status == "pending"
  end
  
  
  SendingTypes = [
    "",
   "perdida",
   "mal-estado",
   "consumo-interno",
   "consumo-externo"]
  
  
end
