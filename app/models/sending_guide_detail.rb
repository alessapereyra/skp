# == Schema Information
#
# Table name: sending_guide_details
#
#  id               :integer(4)      not null, primary key
#  sending_guide_id :integer(4)
#  product_id       :integer(4)
#  quantity         :integer(4)
#  price            :integer(10)
#  created_at       :datetime
#  updated_at       :datetime
#  status           :string(255)
#  pending          :integer(4)
#

class SendingGuideDetail < ActiveRecord::Base

  belongs_to :sending_guide
  belongs_to :product
  
  validates_associated :sending_guide
  validates_associated :product
  
  validates_presence_of :quantity
    
  named_scope :pending, :conditions=>"status like 'open'"
  named_scope :postponed, :conditions=>"status like 'postponed'"  
    
  
  def convert(quote_detail)
    
    self.product_id = quote_detail.product_id
    self.quantity = quote_detail.quantity
    self.price = quote_detail.price
    self.save
    
  end
  
end
