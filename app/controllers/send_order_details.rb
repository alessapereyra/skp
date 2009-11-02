class SendOrderDetailsController < ApplicationController

  before_filter [:has_privileges?,:no_cache]
  
  def destroy
    
    
    
  end


  def update 
    
    @send_order_detail = SendOrderDetail.find(params[:id])
    #@send_order_detail =  
    respond_to do |format|  
    
    if params[:send_order_detail] 
       temp = @send_order_detail.quantity
       @send_order_detail.update_attributes(params[:send_order_detail][params[:id]])
       temp -= @send_order_detail.quantity
       
       @send_order_detail.product.update_stock(-temp)
       @send_order_detail.product.update_store_stock(-temp,Options.GetCurrentStore,self.class,this_method_name)

    end
    
      if @send_order_detail.valid?    
            flash[:notice] = 'Actualizacion completa'
            format.html {  }
            format.xml  {  }
            format.js  { 

                    render :update do |page|
                         page.visual_effect :highlight, 'edit_send_order'            
                         page.replace_html 'messages', flash[:notice]
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
