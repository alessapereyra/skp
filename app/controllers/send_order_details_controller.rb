class SendOrderDetailsController < ApplicationController

  before_filter [:has_privileges?,:no_cache]

  def destroy
    
    SendOrderDetail.transaction do
    
      @send_order_detail = SendOrderDetail.find(params[:id])
      
      #si se elimina, se devuelve el stock, y se actualiza el costo de la Orden de Ingreso
      #si ya se aceptó, se elimina el stock de la tienda destino
      
      @send_order_detail.product.update_store_stock(@send_order_detail.quantity,@send_order_detail.send_order.owner_id,self.class,this_method_name)
       
      if @send_order_detail.send_order.status == "accepted"
        @send_order_detail.product.update_store_stock(@send_order_detail.quantity*-1,@send_order_detail.send_order.store_id,self.class,this_method_name)
      else
        @send_order_detail.product.update_stock(@send_order_detail.quantity)
      end
      @send_order_detail.product.unload_if_pending

=begin     
      @input_order = @send_order_detail.input_order
      @input_order.cost -= @send_order_detail.cost*@send_order_detail.quantity
      @input_order.save
=end
        respond_to do |format|  

            @send_order_detail.destroy                

                flash[:notice] = 'Detalle de orden eliminado'
                format.js  { 

                        render :update do |page|

                                                  
                            #TODO  CAMBIAR POR ELIMINAR SOLO LA FILA
                          
                            # @send_order_details = @input_order.send_order_details           
                             page.remove "row_#{params[:id]}"
                             page.visual_effect :highlight, 'edit_input_order'     
                             page.visual_effect :show, 'detalle'
                             page.replace_html 'messages', "<em id='messages'>#{flash[:notice]}</em>"
                        end
                   }            

        end #respond_to
        
    
    end  #fin transacción
    
  end



  def update 

    error = ""

    begin


      @send_order_detail = SendOrderDetail.find(params[:id])
      #@send_order_detail =  
      respond_to do |format|  

        if params[:send_order_detail] 


          SendOrderDetail.transaction do

            temp = @send_order_detail.quantity
            RAILS_DEFAULT_LOGGER.error("\n Actualizando #{params[:id]}  \n")                 
            RAILS_DEFAULT_LOGGER.error("\n Actualizando #{params[:send_order_detail][params[:id]]}  \n")                             
            RAILS_DEFAULT_LOGGER.error("\n Actualizando #{params[:send_order_detail][params[:id]][:quantity]}  \n")                                         
            RAILS_DEFAULT_LOGGER.error("\n Hay Data  \n")                 
            if params[:send_order_detail][params[:id]][:quantity].to_i > @send_order_detail.product.store_stock(@send_order_detail.send_order.owner_id) && 
              params[:send_order_detail][params[:id]][:quantity].to_i != temp
              error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
              raise
            end  #no hay stock

            RAILS_DEFAULT_LOGGER.error("\n Hay Stock  \n")                 

           @send_order_detail.update_attributes(params[:send_order_detail][params[:id]])
           # @send_order_detail.quantity = params[:send_order_detail][params[:id]][:quantity] unless params[:send_order_detail][params[:id]][:quantity].nil?
          #  @send_order_detail.save!
            RAILS_DEFAULT_LOGGER.error("\n Se actualiza  \n")                 
                        
            temp -= @send_order_detail.quantity

            @send_order_detail.product.update_stock(temp)
            @send_order_detail.product.update_store_stock(temp,@send_order_detail.send_order.owner_id,self.class,this_method_name)
            
                        RAILS_DEFAULT_LOGGER.error("\n Se actualiza stock de tienda y general  \n")                 
            
            if @send_order_detail.send_order.status == 'accepted'  #si la orden ya fue aceptada
                                                              # tambien se modifica el stock del receptor
                  @send_order_detail.product.update_store_stock(temp*-1,@send_order_detail.send_order.store_id,self.class,this_method_name)
                        RAILS_DEFAULT_LOGGER.error("\n Se actualiza del que lo envia  \n")                 
            end
            @send_order_detail.product.unload_if_pending


          end #fin transaccion

        end #no hay params

        if @send_order_detail.valid?    

          flash[:notice] = 'Actualizacion completa'
          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|
                      RAILS_DEFAULT_LOGGER.error("\n Todo válido  \n")                 
              page.visual_effect :highlight, 'edit_send_order'            
              page.replace_html 'messages', "<em id='message'>#{flash[:notice]}</em>"
              page.replace_html 'product_error', ""                        
            end
          }            
        else

          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|
                                RAILS_DEFAULT_LOGGER.error("\n Error #{@send_order_detail.errors }  \n")                 
            end
            #            page.replace 'detalle', :partial => 'product_list'

            #            page.visual_effect :fade, 'product_error'
            #            page.replace_html 'product_error', ""


          }
        end #valid 

      end #respond_to 

  rescue Exception=>ex

    respond_to do |format|  

      format.js  { 
                                RAILS_DEFAULT_LOGGER.error("\n Error #{@send_order_detail.errors }|| #{ex}  \n")    
        render :update do |page|                 
          page.visual_effect :show, 'product_error'    
          page.replace_html 'messages', ""          
          page.replace_html 'product_error', error || "<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos.</em>"
          page.visual_effect :highlight, 'new_product_error'             

        end

      }

    end  #respond

  end  #rescue

end


end
