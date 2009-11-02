class AdminExitOrdersController < ApplicationController

  before_filter [:has_privileges?,:no_cache]
  
  def index
    unless store_admin?
      if get_current_store == 4
    @exit_orders = ExitOrder.paginate(:all, :conditions=>"status not like 'open'",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
    else
      @exit_orders = ExitOrder.paginate(:all, :conditions=>"status not like 'open' and store_id=#{get_current_store} ",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
      
    end
    else
      @exit_orders = ExitOrder.paginate(:all, :conditions=>"status NOT LIKE 'open' and store_id=#{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
    
    end
  end

  def edit
    @exit_order = ExitOrder.find(params[:id], :include=>:exit_order_details)
  end


  def update
    
    @exit_order = ExitOrder.find(params[:id])
    store_id = @exit_order.store_id
    
    @exit_order.update_attributes(params[:exit_order])
    
    if store_id != @exit_order.store_id        # si ha cambiado la tienda de donde se genera la guia de envio
      
      @exit_order.exit_order_details.each do |iod|
          iod.product.update_store_stock(iod.quantity,store_id,self.class,this_method_name) #se devuelve stock a la tienda de donde se origina
          iod.product.update_store_stock(iod.quantity*-1,@exit_order.store_id,self.class,this_method_name) #se le quita stock a la tienda nueva
          
          iod.product.unload_if_pending
      end
      
    end
    
    
    redirect_to admin_exit_orders_catalogue_path
    
  end
  
  def reopen
      session[:exit_order_id] = params[:id]

      ExitOrder.transaction do 
        io = ExitOrder.find(params[:id])
        
        if io.status == "accepted"
          
           if io.unload_stock or self.unload_stock.nil?
             io.exit_order_details.each do |iod|   # cuando se reabre la orden de envio, se devuelve el stock

               iod.product.update_stock(iod.quantity)  # devuelve el stock que se estaba enviando 
               iod.product.update_store_stock(iod.quantity,io.store_id,self.class,this_method_name) #se devuelve el stock a la tienda de donde se origina
          
             end
             
           end #unload_stock
          
      end

       io.status = "pending"
       io.save
       
     end 
     
      redirect_to exit_orders_path
   end
   
   
  
  def delete
    
    ExitOrder.transaction do 
    @exit_order = ExitOrder.find(params[:id])
    @exit_order.exit_order_details.each do |exit_order_detail|       # al eliminar
                                                                     # se devuelve a la tienda original
 
         exit_order_detail.product.update_store_stock(exit_order_detail.quantity,@exit_order.store_id,self.class,this_method_name)
         exit_order_detail.product.update_stock(exit_order_detail.quantity)
         exit_order_detail.product.unload_if_pending
         exit_order_detail.destroy
      
    end
    
    
     @exit_order.destroy

   end
      respond_to do |format|
        format.html { redirect_to admin_exit_orders_catalogue_path }
        format.xml  { head :ok }
      end
    end
    

end
