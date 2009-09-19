class AdminSendingGuidesController < ApplicationController

  before_filter :has_privileges?
  
  def index
    unless store_admin?
      if get_current_store == 4
    @sending_guides = SendingGuide.paginate(:all, :conditions=>"status not like 'open'",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
    else
      @sending_guides = SendingGuide.paginate(:all, :conditions=>"status not like 'open' and (owner_id=#{get_current_store} or store_id=#{get_current_store}) ",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
      
    end
    else
      @sending_guides = SendingGuide.paginate(:all, :conditions=>"status NOT LIKE 'open' and (owner_id=#{get_current_store} or store_id=#{get_current_store})",:order=>"created_at DESC", :page=>params[:page], :per_page => 10)
    
    end
  end

  def edit
    @sending_guide = SendingGuide.find(params[:id], :include=>:sending_guide_details)
  end


  def update
    
    @sending_guide = SendingGuide.find(params[:id])
    store_id = @sending_guide.store_id
    
    @sending_guide.update_attributes(params[:sending_guide])
    
    if store_id != @sending_guide.store_id        # si ha cambiado la tienda de donde se genera la guia de envio
      
      @sending_guide.sending_guide_details.each do |iod|
        if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?
          iod.product.update_store_stock(iod.quantity,store_id,self.class,this_method_name) #se devuelve stock a la tienda de donde se origina
          iod.product.update_store_stock(iod.quantity*-1,@sending_guide.store_id,self.class,this_method_name) #se le quita stock a la tienda nueva
          
          iod.product.unload_if_pending
        end
      end
      
    end
    
    
    redirect_to admin_sending_guides_catalogue_path
    
  end
  
  def reopen
      session[:sending_guide_id] = params[:id]

      SendingGuide.transaction do 
        io = SendingGuide.find(params[:id])
        
        if io.status == "accepted"
          io.sending_guide_details.each do |iod|   # cuando se reabre la orden de envio, se devuelve el stock

            if io.unload_stock or io.unload_stock.nil?   # si la guia descarga stock, o es nil (se sume que nunca se usó)
              iod.product.update_stock(iod.quantity)  # devuelve el stock que se estaba enviando 
              iod.product.update_store_stock(iod.quantity,io.store_id,self.class,this_method_name) #se devuelve el stock a la tienda de donde se origina
          
            end

          end
          
      end

       io.status = "pending"
       io.save
       
     end 
     
      redirect_to sending_guides_path
   end
   
   
  
  def delete
    
    SendingGuide.transaction do 
    @sending_guide = SendingGuide.find(params[:id])
    @sending_guide.sending_guide_details.each do |sending_guide_detail|       # al eliminar
                                                                     # se devuelve a la tienda original
 
        if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?                                                           
         sending_guide_detail.product.update_store_stock(sending_guide_detail.quantity,@sending_guide.store_id,self.class,this_method_name)
         sending_guide_detail.product.update_stock(sending_guide_detail.quantity)
         sending_guide_detail.product.unload_if_pending
        end
         sending_guide_detail.destroy
      
    end
    
    
     @sending_guide.destroy

   end
      respond_to do |format|
        format.html { redirect_to admin_sending_guides_catalogue_path }
        format.xml  { head :ok }
      end
    end
    

end
