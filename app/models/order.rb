# == Schema Information
# Schema version: 20081204141634
#
# Table name: orders
#
#  id               :integer(4)      not null, primary key
#  store_id         :integer(8)
#  order_date       :datetime
#  client_id        :integer(8)
#  address          :string(255)
#  price            :decimal(10, 2)
#  created_at       :datetime
#  updated_at       :datetime
#  type             :string(255)
#  number           :integer(8)
#  status           :string(255)
#  credit_card      :string(255)
#  sending_guide_id :integer(4)
#  unload_stock     :boolean(1)
#  quote_id         :integer(4)
#  orders_generated :boolean(1)
#


class Order < ActiveRecord::Base
  
  self.inheritance_column = "order_type"
  
  has_many :order_details
  has_many :products, :through => :order_details
  
  belongs_to :store
  belongs_to :client
  belongs_to :quote
  belongs_to :sending_guide
  
  named_scope :pending, :conditions=>{:status => "pending"}
  named_scope :accepted, :conditions=>"status like 'accepted' and (unload_stock is true or unload_stock is null)"
  named_scope :unloaded, :conditions =>"unload_stock is false"
  
  def restore

      if status == "accepted"

        self.order_details.each do |iod|

            unless iod.product.nil?

              if self.unload_stock or self.unload_stock.nil?
                iod.product.update_stock(iod.quantity)
                iod.product.update_store_stock(iod.quantity, self.store_id,self.class,this_method_name)
                iod.product.status = "open"
                iod.product.save!

                #iod.product.unload_if_pending
                #iod.product.save!
              end
            end  #no es nulo

        end #each do

      end #terminada

    end
  
  
  def childless?
    self.order_details.empty?
  end
  
  def of_provider?(provider_id)
    
    self.products.any?{|p| p.providers_ids.include? provider_id }
    
  end
    
  def of_category?(category_id)
    self.products.any?{|p| p.category_id == category_id }
  end
  
  def cost
    
    cost = 0
    self.order_details.each do |od|
      
      cost += od.product.cost_price * od.quantity
      
    end
    
    return cost
    
  end
  
  def recalculate_total
        
    
       self.price = 0 
       self.order_details.map { | order_detail | 

         price = order_detail.discount.nil? ? order_detail.price.to_f * order_detail.quantity.to_f : (order_detail.price*(1.0-order_detail.discount/100.0)) * order_detail.quantity.to_f

         self.price += price; self.save  
         
      }
  end
  
  
  
  def self.last_number_of(type,current_store)
        order = Order.find_by_type_and_store_id_and_status(type,current_store,'accepted', :limit=>1, :order=>"number DESC")
        if order
          order.number.nil? ? 1 :  order.number + 1
        else
          1
        end
  end
  
  def name
    self.number
    self.type
  end
  
  def price_without_taxes
    self.price.nil? ? 0 : (self.price/1.19).round(2)  
  end
  
  def taxes
      self.price.nil? ? 0 : self.price - self.price_without_taxes
  end
  
end
