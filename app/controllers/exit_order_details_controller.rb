class ExitOrderDetailsController < ApplicationController

  before_filter :has_privileges?

  def update 

    error = ""

    begin 

      @exit_order_detail = ExitOrderDetail.find(params[:id])
      #@send_exit_order_detail =  
      respond_to do |format|  

      RAILS_DEFAULT_LOGGER.error("\n Llega  \n")                 
      ExitOrderDetail.transaction do

        if params[:exit_order_detail] 
          temp = @exit_order_detail.quantity #10

                RAILS_DEFAULT_LOGGER.error("\n Revisando Stock  \n")                 

          if params[:exit_order_detail][params[:id]][:quantity].to_i > @exit_order_detail.product.store_stock(@exit_order_detail.exit_order.store_id) && 
            params[:exit_order_detail][params[:id]][:quantity].to_i != temp
            error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
                  RAILS_DEFAULT_LOGGER.error("\n No hay stock  \n")                 
            raise
          end  #no hay stock


                  RAILS_DEFAULT_LOGGER.error("\n Si hay stock  \n")       
          @exit_order_detail.update_attributes(params[:exit_order_detail][params[:id]])
                            RAILS_DEFAULT_LOGGER.error("\n Actualizó \n")                 
          temp -= @exit_order_detail.quantity  #4 - 10 = -6    6


          @exit_order_detail.product.update_stock(temp)
          @exit_order_detail.product.update_store_stock(temp,@exit_order_detail.exit_order.store_id)
          @exit_order_detail.product.unload_if_pending
          @exit_order = @exit_order_detail.exit_order 
                            RAILS_DEFAULT_LOGGER.error("\n Actualizo stock  \n")                     
          @exit_order.price = 0
          @exit_order.exit_order_details.each do |od|

            price = od.discount.nil? ? od.price*od.quantity : (od.price*(1.0-od.discount/100.0)) * od.quantity
            @exit_order.price += price
                  RAILS_DEFAULT_LOGGER.error("\n Actualizo precio  \n")                 
          end
          
          @exit_order.save!
          
        end  #si hay datos de detalle de orden
        end # fin transaccion 
        
        if @exit_order_detail.valid?   
          @exit_order_detail.save 
          
                  RAILS_DEFAULT_LOGGER.error("\n Todo bien  \n")                 
          flash[:notice] = 'Actualizacion completa'
          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|
              #@order = @exit_order_detail.order
              page.replace 'detalle_list', :partial => 'admin_exit_orders/detail_product_list'                     
              page.visual_effect :highlight, 'edit_order'            
              page.replace_html 'messages', "<em id='message'>#{flash[:notice]}</em>"
              page.replace_html 'subtotal', "Total: S/. #{@exit_order.price}"
              page.replace_html 'product_error', ""
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

  rescue Exception => ex

    respond_to do |format|  
                  RAILS_DEFAULT_LOGGER.error("\n No hay stock  \n")   
                                    RAILS_DEFAULT_LOGGER.error("\n #{ex}  \n")           
      format.js  { 

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

def destroy
  
  ExitOrderDetail.transaction do
  
    @exit_order_detail = ExitOrderDetail.find(params[:id])
    
    #si se elimina, se devuelve el stock, y se actualiza el costo de la Orden de Ingreso
    #si ya se aceptó, se elimina el stock de la tienda destino
      @exit_order = @exit_order_detail.exit_order      
      @exit_order.price -= @exit_order_detail.subtotal
      @exit_order.save
      
      @exit_order_detail.product.update_store_stock(@exit_order_detail.quantity,@exit_order_detail.exit_order.store_id)
      @exit_order_detail.product.update_stock(@exit_order_detail.quantity)
      @exit_order_detail.product.unload_if_pending
      
      
      respond_to do |format|  

          @exit_order_detail.destroy                

              flash[:notice] = 'Detalle de orden eliminado'
              format.js  { 

                      render :update do |page|
                        
                          #TODO  CAMBIAR POR ELIMINAR SOLO LA FILA
                        
                          # @exit_order_details = @input_order.exit_order_details           
                           page.visual_effect :highlight, 'edit_input_order'     
                           page.remove "row_#{params[:id]}"
                           page.visual_effect :show, 'detalle'
                           page.replace_html 'messages', "<em id='messages'>#{flash[:notice]}</em>"
                      end
                 }            
        
      end #respond_to
      
  
  end  #fin transacción
  
end




end