class SendingGuideDetailsController < ApplicationController

  before_filter [:has_privileges?,:no_cache]

  def destroy
    
    SendingGuideDetail.transaction do
    
      @sending_guide_detail = SendingGuideDetail.find(params[:id])
      
      #si se elimina, se devuelve el stock, y se actualiza el costo de la Orden de Ingreso
      #si ya se aceptó, se elimina el stock de la tienda destino
        @sending_guide = @sending_guide_detail.sending_guide      
        
      if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?
        @sending_guide_detail.product.update_store_stock(@sending_guide_detail.quantity,@sending_guide_detail.sending_guide.store_id,self.class,this_method_name)
        @sending_guide_detail.product.update_stock(@sending_guide_detail.quantity)
        @sending_guide_detail.product.unload_if_pending
      end
        
        respond_to do |format|  

            @sending_guide_detail.destroy                

                flash[:notice] = 'Detalle de orden eliminado'
                format.js  { 

                        render :update do |page|
                          
                            #TODO  CAMBIAR POR ELIMINAR SOLO LA FILA
                          
                            # @sending_guide_details = @input_order.sending_guide_details           
                             page.visual_effect :highlight, 'edit_input_order'     
                             page.remove "row_#{params[:id]}"
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


      @sending_guide_detail = SendingGuideDetail.find(params[:id])
      #@sending_guide_detail =  
      respond_to do |format|  

        if params[:sending_guide_detail] 


          SendingGuideDetail.transaction do

            temp = @sending_guide_detail.quantity
            @sending_guide = @sending_guide_detail.sending_guide
            logger.info "Valor actual #{temp}"
            logger.info "Valor a modificar #{params[:sending_guide_detail][params[:id]][:quantity].to_i}" 
            logger.info "Stock de tienda #{@sending_guide_detail.product.store_stock(@sending_guide_detail.sending_guide.store_id)}"
            
            if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?
            logger.info "Si descarga stock"            
              if params[:sending_guide_detail][params[:id]][:quantity].to_i > @sending_guide_detail.product.store_stock(@sending_guide_detail.sending_guide.store_id) && 
                params[:sending_guide_detail][params[:id]][:quantity].to_i != temp
                error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
                            logger.info "No hay stock"
                raise
              end  #no hay stock

            end

            @sending_guide_detail.update_attributes(params[:sending_guide_detail][params[:id]])
            @sending_guide_detail.save!
            logger.info "Grabó"
            temp -= @sending_guide_detail.quantity

            if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?
                          logger.info "Si descarga stock"
              @sending_guide_detail.product.update_stock(temp)
              @sending_guide_detail.product.update_store_stock(temp,@sending_guide_detail.sending_guide.store_id,self.class,this_method_name)
            end

            if @sending_guide.status == 'accepted'  #si la orden ya fue acceptada
                                                              # tambien se modifica el stock del receptor
             if @sending_guide.unload_stock or @sending_guide.unload_stock.nil?
                             logger.info "Si descarga stock"
                  @sending_guide_detail.product.update_store_stock(temp*-1,@sending_guide_detail.sending_guide.order_id,self.class,this_method_name)
              end
            end
            @sending_guide_detail.product.unload_if_pending
            logger.info "Fin transacción"

          end #fin transaccion

        end #no hay params

        if @sending_guide_detail.valid?    
          flash[:notice] = 'Actualizacion completa'
                      logger.info "Actualización correcta"
          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|
              page.visual_effect :highlight, 'edit_sending_guide'            
              page.replace_html 'messages', "<em id='message'>#{flash[:notice]}</em>"
              page.replace_html 'product_error', ""                        
            end
          }            
        else
          logger.info "Error en actualización: #{@sending_guide_detail.errors}"           
          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|

            end
            #            page.replace 'detalle', :partial => 'product_list'

            #            page.visual_effect :fade, 'product_error'
            #            page.replace_html 'product_error', ""


          }
        end #valid 

      end #respond_to 

  rescue Exception => ex

    respond_to do |format|  

            logger.info "#{ex}"
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


end
