class OrdersController < ApplicationController

  before_filter [:has_privileges?,:no_cache]
  
  def index
    @boletas = @facturas = []
    
    unless store_admin?
      if get_current_store == 4
             @facturas = Order.paginate(:all, :order=>"number DESC", :conditions=>"type like 'factura' and status LIKE 'accepted'",:page=>params[:page], :per_page => 5)    
              @boletas = Order.paginate(:all, :order=>"number DESC", :conditions=>"type like 'boleta' and status LIKE 'accepted'",:page=>params[:page], :per_page => 5)    
        else
              @boletas = Order.paginate(:all, :order=>"number DESC", :conditions=>"store_id = #{get_current_store} and type like 'boleta' and status LIKE 'accepted'",:page=>params[:page], :per_page => 5)    
              @facturas = Order.paginate(:all, :order=>"number DESC", :conditions=>"store_id = #{get_current_store} and type like 'factura' and status LIKE 'accepted'",:page=>params[:page], :per_page => 5)    
    

    end
    else

           @boletas = Order.paginate(:all, :order=>"number DESC", :conditions=>"type like 'boletas' and status LIKE 'accepted' and store_id = #{get_current_store}",:page=>params[:page], :per_page => 5)    
           @facturas = Order.paginate(:all, :order=>"number DESC",:conditions=>"type like 'facturas' and status LIKE 'accepted' and store_id = #{get_current_store}",:page=>params[:page], :per_page => 5)    
      
      
    end
  end

  def edit
    @order = Order.find(params[:id], :include=>:order_details)
    @order.unload_stock = true if @order.unload_stock.nil? 
    @order.save
  end


  def update
    
        @order = Order.find(params[:id])
        
        store_id = @order.store_id

        year = params[:order]["order_date(1i)"] 
        month = params[:order]["order_date(2i)"] 
        day = params[:order]["order_date(3i)"]
        @order.order_date = Time.zone.parse("#{year}-#{month}-#{day}")        

        @order.store_id =  params[:order][:store_id] # get_current_store
        @order.client_id = params[:order][:hidden_client_id]
        @order.type  = params[:order][:type] || "boleta"
        @order.unload_stock = params[:order][:unload_stock]
        @order.address = @order.client.address unless @order.client.nil?
        @order.number = params[:order][:number]  #Order.last_number_of(@order.type,get_current_store)

        if store_id != @order.store_id    # si se cambia de tienda, se devuelven los productos de la original
                                          # y se estan a la nueva 
          @order.order_details.each do |od|
            
            if @order.unload_stock or @order.unload_stock.nil?
              od.product.update_store_stock(od.quantity,store_id,self.class,this_method_name)
              od.product.update_store_stock(od.quantity*-1,@order.store_id,self.class,this_method_name)
              od.product.unload_if_pending
            end
            
          end # each            
          
        end  # si se cambio de tienda
        
          @order.order_details.each do |od|  #si se marcó como no descargar, recalcular el stock de sus productos
        
            if @order.unload_stock or @order.unload_stock.nil?
              od.product.recalculate_stocks
              od.product.recalculate_stocks_of_store(@order.store_id) 
            end
          end
        


      respond_to do |format|
        if @order.valid?
          @order.save!
          flash[:notice] = 'Orden de Envío actualizada'
          format.html { redirect_to orders_catalogue_path }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
        end
      end
    
  end
  
  def delete
    
    Order.transaction do 
    @order = Order.find(params[:id])
    @order.order_details.each do |order_detail|

      if @order.unload_stock
        order_detail.product.update_stock(order_detail.quantity)
        order_detail.product.update_store_stock(order_detail.quantity,@order.store_id,self.class,this_method_name)
        order_detail.product.unload_if_pending
      end
      
      order_detail.destroy
      
    end
    
    
     @order.destroy

   end
      respond_to do |format|
        format.html { redirect_to orders_catalogue_path }
        format.xml  { head :ok }
      end
    end
    


  

end
