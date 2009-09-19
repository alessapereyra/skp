class InputOrdersController < ApplicationController

  before_filter :has_privileges?
  
  def index
    
    unless store_admin?
      if get_current_store == 4
    @input_orders = InputOrder.paginate(:all, :conditions=>"status like 'terminada'",:order=>"created_at DESC", :page=>params[:page], :per_page => 5, :include => [:provider])
    else
      @input_orders = InputOrder.paginate(:all, :conditions=>"status like 'terminada' and store_id=#{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 5, :include => [:provider])
    
    end
  else
    @input_orders = InputOrder.paginate(:all, :conditions=>"status LIKE 'terminada' and store_id = #{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 5, :include => [:provider])
  end
  
  end

  def massive_edit
    
      unless store_admin?
        if get_current_store == 4
      @input_orders = InputOrder.paginate(:all, :conditions=>"status like 'terminada'",:order=>"created_at DESC", :page=>params[:page], :per_page => 25)
      else
        @input_orders = InputOrder.paginate(:all, :conditions=>"status like 'terminada' and store_id=#{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 25)

      end
    else
      @input_orders = InputOrder.paginate(:all, :conditions=>"status LIKE 'terminada' and store_id = #{get_current_store}",:order=>"created_at DESC", :page=>params[:page], :per_page => 25)
    end
    
    
  end

  def edit
    @input_order = InputOrder.find(params[:id], :include=>:input_order_details)
    @prices = []
    @input_order.input_order_details.each {|iod| @prices << iod.prices  }
  end


  def reopen
     session[:input_order_id] = params[:id]
    
      io = InputOrder.find(params[:id])

      if io.status == "terminada"
        io.input_order_details.each do |iod|   # cuando se reabre la orden de ingreso, se elimina el stock
      
          if io.unload_stock or io.unload_stock.nil?
            iod.product.update_stock(iod.quantity*-1)
            iod.product.update_store_stock(iod.quantity*-1,io.store_id,self.class,this_method_name)
          end
      
        end
     end
        io.status = "pendiente"
      io.save
    
    
     redirect_to input_orders_path
  end


  def update
    
      InputOrder.transaction do 
        
      @input_order = InputOrder.find(params[:id])
      
      store_id = @input_order.store_id
      

      respond_to do |format|
        if @input_order.update_attributes(params[:input_order])
          
          if store_id != @input_order.store_id                                # si ha cambiado la tienda a la que se ingresa
                                                                              # mercadería, se quita de la original y se agrega
                  @input_order.input_order_details.each do |iod|              # a la nueva
                    
                      if (@input_order.unload_stock or @input_order.unload_stock.nil?)
                        iod.product.update_store_stock(iod.quantity*-1,store_id,self.class,this_method_name)
                        iod.product.update_store_stock(iod.quantity,@input_order.store_id,self.class,this_method_name)
                        iod.product.unload_if_pending
                      end

                      iod.product.save!
                      
                    
                  end # each

          end  #si se cambia de tienda
          
          @input_order.cost = @input_order.input_order_details.inject(0){| sum, iod | sum + (iod.cost.to_f*iod.quantity)  }
          @input_order.save
          
          flash[:notice] = "Orden de Ingreso #{@input_order.document} actualizada"
          format.html { redirect_to input_orders_catalogue_path }
          format.xml  { head :ok }
          format.js { 
            
            render :update do |page|
                 page.visual_effect :highlight, "row_#{@input_order.id}"                           
                 page.visual_effect :highlight, 'edit_input_order'                             
                 page.replace_html "messages", "<em id='messages'>#{flash[:notice]}</em>"
            end
            
            
            }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @input_order.errors, :status => :unprocessable_entity }
          format.js { render :text =>"Error" }
        end
      end  # respond_to
      
    end  #fin transacción
     
  end
  
  
  def delete
    
    InputOrder.transaction do 
    @input_order = InputOrder.find(params[:id])
    @input_order.input_order_details.each do |input_order_detail|

      if @input_order.unload_stock or @input_order.unload_stock.nil?
        input_order_detail.product.update_stock(input_order_detail.quantity*-1)
        input_order_detail.product.update_store_stock(input_order_detail.quantity*-1,@input_order.store_id,self.class,this_method_name)
        input_order_detail.product.unload_if_pending
        input_order_detail.destroy
      end

    end
    
    
     @input_order.destroy

   end
      respond_to do |format|
        format.html { redirect_to input_orders_catalogue_path }
        format.xml  { head :ok }
      end
    end
  
  

end
