class InputOrderDetailsController < ApplicationController

  before_filter [:has_privileges?,:no_cache]
  
  def destroy
    
    InputOrderDetail.transaction do
    
      @input_order_detail = InputOrderDetail.find(params[:id])
      
      #si se elimina, se elimina el stock, y se actualiza el costo de la Orden de Ingreso
      @input_order = @input_order_detail.input_order
      
     if @input_order.status == "terminada" 
       if @input_order.unload_stock or @input_order.unload_stock.nil?
         @input_order_detail.product.update_stock(@input_order_detail.quantity*-1)
         @input_order_detail.product.update_store_stock(@input_order_detail.quantity*-1,@input_order_detail.input_order.store_id,self.class,this_method_name)
         @input_order_detail.product.unload_if_pending
       end
      end

      @input_order.cost -= @input_order_detail.cost*@input_order_detail.quantity
      @input_order.save

        respond_to do |format|  

          if @input_order.valid?
            @input_order_detail.destroy                

                flash[:notice] = 'Detalle de orden eliminado'
                format.js  { 

                        render :update do |page|

                          @input_order
                          @input_order.input_order_details
                          
                          
                            #TODO  CAMBIAR POR ELIMINAR SOLO LA FILA
                          
                            # @input_order_details = @input_order.input_order_details           
                             page.visual_effect :highlight, 'edit_input_order'     
                             page.remove "row_#{params[:id]}"
                             page.visual_effect :show, 'detalle'
                             page.replace_html 'messages', "<em id='messages'>#{flash[:notice]}</em>"
                        end
                   }            
          else
            
            flash[:error] = 'Error al eliminar el detalle'
            format.js  { 

                    render :update do |page|
                         page.visual_effect :highlight, 'edit_input_order'     
                         page.replace_html 'messages', "<em id='messages'>#{flash[:error]}</em>"
                    end
               }            
            

          end
          
        end #respond_to
        
    
    end  #fin transacción
    
  end


  def new
    
  end
  
  
  def create 
    
    
  end

  def update 
    
    @input_order_detail = InputOrderDetail.find(params[:id])
    
    if @input_order_detail.prices[0]
        @input_order_detail.prices[0].amount = params[:price][:amount].to_f    
        @input_order_detail.prices[0].save
    else
       new_price = Price.new
       new_price.amount = params[:price][:amount].to_f
       new_price.description = "Precio base"
       new_price.discount = 0.0
       new_price.save
    	@input_order_detail.prices << new_price
      @input_order_detail.save!
    end

    if @input_order_detail.prices[1]    
      @input_order_detail.prices[1].amount = params[:price][:boxed_price].to_f
      @input_order_detail.prices[1].save
    else
       new_price = Price.new
       new_price.amount = params[:price][:boxed_price].to_f
       new_price.description = "Precio mayorista"
       new_price.discount = 0
       new_price.save       
    	@input_order_detail.prices << new_price
      @input_order_detail.save!
      
    end
  
    if @input_order_detail.prices[2]    
      @input_order_detail.prices[2].amount = params[:price][:wholesale_price].to_f
      @input_order_detail.prices[2].save
    else
       new_price = Price.new
       new_price.amount = params[:price][:wholesale_price].to_f
       new_price.discount = 0
       new_price.description= "Precio en caja"
       new_price.save       
    	@input_order_detail.prices << new_price
      @input_order_detail.save!
      
    end
  
    p = @input_order_detail.product
    p.corporative_price = params[:price][:wholesale_price].to_f
    p.save
    
    if @input_order_detail.prices[3]
      @input_order_detail.prices[3].amount = params[:price][:final_price].to_f
      @input_order_detail.prices[3].save
    else
       new_price = Price.new
       new_price.amount = params[:price][:final_price].to_f
       new_price.discount = 0
       new_price.description = "Precio Tienda 1"       
       new_price.save       
    	@input_order_detail.prices << new_price
      @input_order_detail.save!
      
    end
    
    if @input_order_detail.prices[4].nil? 
        new_price = Price.new
        new_price.amount = 0.0
        new_price.discount = 0.0
        updatenew_price.description = "Precio Tienda 2"               
        new_price.save
	@input_order_detail.prices << new_price
        @input_order_detail.save!
    end		

    @input_order_detail.prices[4].amount = params[:price][:final_price_polo].to_f unless @input_order_detail.prices[4].nil?                        
    @input_order_detail.prices[4].save unless @input_order_detail.prices[4].nil?                        
    
    
    respond_to do |format|  
    
    if params[:input_order_detail] 
       temp = @input_order_detail.quantity
       @input_order_detail.update_attributes(params[:input_order_detail][params[:id]])
       temp -= @input_order_detail.quantity

       input_order = @input_order_detail.input_order

       if input_order.unload_stock or input_order.unload_stock.nil?
         @input_order_detail.product.update_stock(-temp)
         @input_order_detail.product.update_store_stock(-temp,@input_order_detail.input_order.store_id,self.class,this_method_name)
         @input_order_detail.product.unload_if_pending
       end
    end
    
      if @input_order_detail.valid?    
            flash[:notice] = 'Actualizacion exitosa'
            format.html {  }
            format.xml  {  }
            format.js  { 
  
                    render :update do |page|
                         page.visual_effect :highlight, 'edit_input_order'     
                         page.visual_effect :highlight, "row_#{@input_order_detail.id}"                                     
                         page.replace_html 'messages', "<em id='messages'>#{flash[:notice]}</em>"
                    end
               }            
    else
            format.html {  }
            format.xml  {  }
            format.js  { 
              
                    render :update do |page|
                                    
                    end
              #            page.replace 'detalle', :partial => 'product_list'

              #            page.visual_effect :fade, 'product_error'
              #            page.replace_html 'product_error', ""
              
              
               }
    end
    
  end
          
=begin
     respond_to do |format|
        format.js  { 
          render :update do |page|

#            page.replace 'detalle', :partial => 'product_list'
#            page.visual_effect :highlight, 'product_table'            
#            page.visual_effect :fade, 'product_error'
#            page.replace_html 'product_error', ""

          end

          }
      end
=end
  end

end
