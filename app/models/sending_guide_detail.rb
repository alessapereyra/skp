# == Schema Information
#
# Table name: sending_guide_details
#
#  id               :integer(4)      not null, primary key
#  sending_guide_id :integer(4)
#  product_id       :integer(4)
#  quantity         :decimal(10, 2)
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
    
  named_scope :pending_guide, :joins=>:sending_guide, :conditions=>["sending_guides.status like ?","pending"]

  named_scope :returned,  :joins=>:sending_guide,:conditions=>["sending_guides.status like ?","returned"]

  named_scope :accepted,  :joins=>:sending_guide, :conditions=>"sending_guides.status like 'accepted' and (sending_guides.unload_stock is true or sending_guides.unload_stock is null)"
  named_scope :unloaded,  :joins=>:sending_guide, :conditions =>"sending_guides.unload_stock is false" 
  named_scope :of_store, lambda{|store_id| {:conditions=>["sending_guides.store_id like ?",store_id]}}
	named_scope :period, lambda { |period| { :joins=>:sending_guide, :conditions=>["sending_guides.sending_date >= ? and sending_guides.sending_date < ? ",period[:from], period[:to]] } }


  def convert(quote_detail)
    
    self.product_id = quote_detail.product_id
    self.quantity = quote_detail.quantity
    self.price = quote_detail.price
    self.save
    
  end
  
end
