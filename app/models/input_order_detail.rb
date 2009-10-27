# == Schema Information
# Schema version: 20090320214122
#
# Table name: input_order_details
#
#  id              :integer(4)      not null, primary key
#  quantity        :decimal(10, 2)
#  cost            :decimal(10, 2)
#  product_id      :integer(8)
#  created_at      :datetime
#  updated_at      :datetime
#  input_order_id  :integer(8)
#  additional_code :string(255)
#  prices_count    :integer(4)      default(0)
#

class InputOrderDetail < ActiveRecord::Base

  
  belongs_to :input_order, :counter_cache => true
  belongs_to :product
  has_many :prices
  
  validates_numericality_of :product_id
  validates_presence_of :product_id, :on => :create, :message => "debe existir"
  validates_associated :product
  validates_numericality_of :quantity, :on => :create, :message => "no es un número"
  validates_presence_of :cost

	named_scope :accepted, :joins=>:input_order, :conditions=>["input_orders.status like ?","terminada"]
	named_scope :pending,  :joins=>:input_order, :conditions=>["input_orders.status like ?","pendiente"]
	named_scope :of_store, lambda{|store_id| {:conditions=>["input_orders.store_id like ?",store_id]}}
	named_scope :period, lambda { |period| { :joins=>:input_order, :conditions=>["input_orders.order_date >= ? and input_orders.order_date < ? ",period[:from], period[:to]] } }
		

  def subtotal
    
    
    
  end
  
  def base_price
    self.prices.find_by_description("Precio base",:conditions=>"amount is not null", :limit=>1,:order=>"created_at DESC")
  end
  
  def corporative_price
    self.prices.find_by_description("Precio mayorista",:conditions=>"amount is not null",:limit=>1,:order=>"created_at DESC")
  end
  
  def wholesale_price
    self.prices.find_by_description("Precio en caja",:conditions=>"amount is not null",:limit=>1,:order=>"created_at DESC")    
  end
  
  def trigal_price
    self.prices.find_by_description("Precio Tienda 1",:conditions=>"amount is not null",:limit=>1,:order=>"created_at DESC")
  end
  
  def polo_price
    self.prices.find_by_description("Precio Tienda 2",:conditions=>"amount is not null",:limit=>1,:order=>"created_at DESC")    
  end
  
    
end
