class OrderDetailsController < ApplicationController

  before_filter [:has_privileges?,:no_cache]

  def update 

    error = ""

    begin 

      @order_detail = OrderDetail.find(params[:id])
      #@send_order_detail =  
      respond_to do |format|  


      OrderDetail.transaction do
        if params[:order_detail] 
          temp = @order_detail.quantity #10

          if params[:order_detail][params[:id]][:quantity].to_i > @order_detail.product.store_stock(@order_detail.order.store_id) && 
            params[:order_detail][params[:id]][:quantity].to_i != temp
            error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
            raise
          end  #no hay stock

          @order_detail.update_attributes(params[:order_detail][params[:id]])
          temp -= @order_detail.quantity  #4 - 10 = -6    6


          @order_detail.product.update_stock(temp)
          @order_detail.product.update_store_stock(temp,@order_detail.order.store_id,self.class,this_method_name)
          @order_detail.product.unload_if_pending
          @order = @order_detail.order 
              
          @order.price = 0
          @order.order_details.each do |od|

            price = od.discount.nil? ? od.price*od.quantity : (od.price*(1.0-od.discount/100.0)) * od.quantity
            @order.price += price

          end
          
          @order.save!
          
        end  #si hay datos de detalle de orden
        end # fin transaccion 
        
        if @order_detail.valid?   
          @order_detail.save 
          

          flash[:notice] = 'Actualizacion completa'
          format.html {  }
          format.xml  {  }
          format.js  { 

            render :update do |page|
              #@order = @order_detail.order
              page.replace 'detalle_list', :partial => 'orders/detail_product_list'                     
              page.visual_effect :highlight, 'edit_order'            
              page.replace_html 'messages', "<em id='message'>#{flash[:notice]}</em>"
              page.replace_html 'subtotal', "Total: S/. #{@order.price}"
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

  rescue

    respond_to do |format|  

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