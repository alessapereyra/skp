# == Schema Information
# Schema version: 20090320214122
#
# Table name: quotes
#
#  id                  :integer(4)      not null, primary key
#  client_id           :integer(4)
#  store_id            :integer(4)
#  user_id             :integer(4)
#  client_address      :string(255)
#  quote_date          :datetime
#  duration            :integer(4)
#  sending_details     :string(255)
#  quote_comments      :text
#  created_at          :datetime
#  updated_at          :datetime
#  document            :string(255)
#  status              :string(255)
#  contact_name        :string(255)
#  price_type          :string(255)
#  updated             :boolean(1)
#  sent                :boolean(1)
#  child_number        :integer(4)
#  budget              :decimal(10, 2)
#  is_requested        :boolean(1)
#  orders_generated    :boolean(1)
#  quote_details_count :integer(4)      default(0)
#  from_web            :boolean(1)
#

class Quote < ActiveRecord::Base
  
  has_many :quote_details,:order=>"created_at DESC"
  has_many :age_ranges,:order=>"age_from DESC,age_to DESC"
  has_many :orders
  
  belongs_to :client
  belongs_to :user
  belongs_to :store
  
  named_scope :pending, :conditions=>{:status => "pending"}
  named_scope :accepted, :conditions=>{:status => "accepted"} 
  named_scope :requested, :conditions=>{:status => "requested"} 
  
  has_many :products, :through => :quote_details


  def mark_as_read
    self.updated = false
    self.save
  end
  
  def total_products
     
     total_products = 0    
     
     self.quote_details.final.each do |qd|
       unless qd.quantity.nil?
         total_products += qd.quantity 
       end
     end
     
     return total_products
  end
  
  def self.last_number
        quote = Quote.find_by_status('accepted', :limit=>1, :order=>"document DESC")
        if quote
          quote.document.nil? ? 1 :  quote.document.to_i + 1
        else
          1
        end
  end
  
  def masculine_total
    sum = 0
    self.age_ranges.each do |age_range|
      sum += age_range.masculine unless age_range.masculine.blank?
    end
    sum
  end
  
  def femenine_total
    sum = 0
    self.age_ranges.each do |age_range|
      sum += age_range.femenine unless age_range.femenine.blank?
    end
    sum
  end
  
  def ranges_total
    masculine_total + femenine_total
  end
  
  def childless?
    self.quote_details.empty?
  end
  
  def stock_completed?
    
    self.quote_details.all? {|qd| qd.pending.zero? }
    
  end
  
  def unload_stock
    # SOLO SE HACE 1 VEZ
    
    products = []
    self.products.each do |p| products << p unless products.include? p end
    products.each do |p| p.recalculate_stocks_without_requests  end    # calculo el stock 
          
    self.quote_details.each do |qd|
      
      
      
    end
    
  end
  
  def price
    price = 0
    self.quote_details.final.each do |qd|
      price += qd.subtotal unless qd.subtotal.nil?
    end
    price
  end
  
  
end
