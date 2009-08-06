class AcceptanceController < ApplicationController

  def index
    @pending_send_orders = SendOrder.find(:all, :order=>"updated_at DESC",  :conditions=>"status LIKE 'pending' and store_id = #{get_current_store}")
  end
   
  def send_order
    @send_order = SendOrder.find(params[:id])
  end

  def accept_order
    
    SendOrder.transaction do

      @send_order = SendOrder.find(params[:id])
    
      #Estamos aceptando la orden en la tienda que lo acepta 
      # owner_id = El que envia
      # store_id = El que recibe
       
      @send_order.send_order_details.each do |sod|
      
        sod.product.update_stock(sod.quantity)    # aumenta el stock global
        sod.product.update_store_stock(sod.quantity,@send_order.store_id,self.class,this_method_name)  #aumenta el stock en la tienda que recibe
      
        sod.product.unload_if_pending
      
      end
    
      @send_order.status = "accepted"
      @send_order.received_date = Time.zone.now
      if @send_order.save!
      
        redirect_to acceptance_path
      
      else
        redirect_to acceptance_path  
      end

    end
    
  end

end
