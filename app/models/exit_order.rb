# == Schema Information
#
# Table name: exit_orders
#
#  id                       :integer(4)      not null, primary key
#  store_id                 :integer(4)
#  client_id                :integer(4)
#  sending_date             :datetime
#  driver_name              :string(255)
#  driver_dni               :string(255)
#  extra_data               :text
#  created_at               :datetime
#  updated_at               :datetime
#  status                   :string(255)
#  document                 :string(255)
#  unload_stock             :boolean(1)
#  address                  :string(255)
#  price                    :decimal(10, 2)
#  exit_order_details_count :integer(4)      default(0)
#

class ExitOrder < ActiveRecord::Base

  has_many :exit_order_details
  has_many :products, :through => :exit_order_details
  belongs_to :client
  belongs_to :store
  
  named_scope :pending, :conditions=>{:status => "pending"}
  named_scope :accepted, :conditions=>"`exit_orders`.status like 'accepted'"
  
  
  def self.get_pending_of(id)
    
    exit_orders = ExitOrder.find(:all, :conditions=>"status like 'pending' and id != #{id}")
    exit_orders.select {|t| not t.childless? }
    
  end
  
  def restore

     if status == "accepted"

       self.exit_order_details.each do |iod|

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
  

  def cost
    
    cost = 0
    self.exit_order_details.each do |od|
      
      cost += od.product.cost_price * od.quantity
      
    end
    
    return cost
    
  end
  
  def self.clients

    clients = []
    ExitOrder.all.map{|eo| clients << eo.client unless clients.include? eo.client or eo.client.nil? }
    if clients.empty?
      clients << Client.new({:name=>"Ninguno"})
    end
    clients
  end

  def childless?
    self.exit_order_details.empty?
  end
  
  def self.last_number_of(store)
    
    exit_order = ExitOrder.find_by_store_id_and_status(store,'accepted',:limit=>1,:order=>"document DESC")
    if exit_order
      exit_order.document.nil? ? 1 : exit_order.document.next
    else
      1
    end
        
  end
  
  def recalculate_total

        self.price = 0
         self.exit_order_details.each do |od|
            price = od.discount.nil? ? od.price*od.quantity : (od.price*(1.0-od.discount/100.0)) * od.quantity
            self.price += price
          RAILS_DEFAULT_LOGGER.error("\n Actualizo precio  \n")                 
          end
          
          self.save
    
  end
  
end
