class SendOrdersController < ApplicationController

  before_filter :has_privileges?
  
  def index
    unless store_admin?
      if get_current_store == 4
    @send_orders = SendOrder.paginate(:all, :conditions=>"status not like 'open'",:order=>"created_at DESC", :page=>params[:page], :per_page => 15)
    else
      @send_orders = SendOrder.paginate(:all, :conditions=>"status not like 'open' and owner_id=#{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 15)
      
    end
    else
      @send_orders = SendOrder.paginate(:all, :conditions=>"status NOT LIKE 'open' and owner_id=#{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 15)
    
    end
  end

  def edit
    @send_order = SendOrder.find(params[:id], :include=>:send_order_details)
  end
  
  def recover
  
         session[:send_order_id] = params[:id]

          io = SendOrder.find(params[:id])
          
          if io.status == "accepted" or io.status == "pending"
              io.send_order_details.each do |sod|   # cuando se reabre la orden de envio, se devuelve el stock


                sod.product.update_stock(sod.quantity)
                sod.product.update_store_stock(sod.quantity,io.owner_id,self.class,this_method_name)

                    if io.status == "accepted"        # si ya habia sido aceptada, se quita el stock de la tienda receptora
                      sod.product.update_store_stock(sod.quantity*-1,io.store_id,self.class,this_method_name)              
                    end


              end
          end #si estaba cerrada

          io.status = "open"
          io.save


         redirect_to sending_path
    
  end


  def update
    
      SendOrder.transaction do
      @send_order = SendOrder.find(params[:id])
      received_date = @send_order.received_date
      store_id = @send_order.store_id
      owner_id = @send_order.owner_id
      change_endpoint = false
      change_owner = false
      
      
      respond_to do |format|
        if @send_order.update_attributes(params[:send_order])
          @send_order.received_date = nil if received_date.nil? 
          
          if owner_id != @send_order.owner_id #  si se elige a otra tienda como propietaria, se le devuelve el stock
                   
                   change_owner = true                           # a la original y quita a la nueva
                                                          
          end # cambio de dueño
          
          if store_id != @send_order.store_id && @send_order.status == 'accepted'  # si se cambia el destinatario de la orden
                                                                                   # y esta orden ya fue aceptada, se 
                                                                                   # disminuye el stock de la original
                  change_endpoint = true                                          # y se aumenta el nuevo destinatario
            
            
          end # cambio de destinatario
          
          
          #aplicamos los cambios anteriores
          @send_order.send_order_details.each do |sod|
            
            if change_owner
              sod.product.update_store_stock(sod.quantity,owner_id,self.class,this_method_name)
              sod.product.update_store_stock(sod.quantity*-1,@send_order.owner_id,self.class,this_method_name)              
              sod.product.unload_if_pending
            end
            
            if change_endpoint

              sod.product.update_store_stock(sod.quantity,@send_order.store_id,self.class,this_method_name)
              sod.product.update_store_stock(sod.quantity*-1,store_id,self.class,this_method_name)                            
              sod.product.unload_if_pending
            end
            
          end # each
          
          
          
          
          @send_order.save
            
          flash[:notice] = 'Orden de Envío actualizada'
          format.html { redirect_to send_orders_catalogue_path }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @send_order.errors, :status => :unprocessable_entity }
        end
      end  # respond
    
    end #fin transacción
    
  end
  
  def delete
    
    SendOrder.transaction do 
    @send_order = SendOrder.find(params[:id])
    @send_order.send_order_details.each do |send_order_detail|       # al eliminar, si ya fue aceptado
                                                                     # se quita el stock de la tienda destino
                                                                     # y se devuelve a la original
                                                                     # si no, sólo se devuelve a la original
 

       if @send_order.status == "accepted" 

         send_order_detail.product.update_store_stock(-send_order_detail.quantity,@send_order.store_id,self.class,this_method_name)
         send_order_detail.product.update_store_stock(send_order_detail.quantity,@send_order.owner_id,self.class,this_method_name)

       else
         send_order_detail.product.update_stock(send_order_detail.quantity)
         send_order_detail.product.update_store_stock(send_order_detail.quantity,@send_order.owner_id,self.class,this_method_name)
               
       end                                               
       send_order_detail.product.unload_if_pending

      send_order_detail.destroy
      
    end
    
    
     @send_order.destroy

   end
      respond_to do |format|
        format.html { redirect_to send_orders_catalogue_path }
        format.xml  { head :ok }
      end
    end
    

end
