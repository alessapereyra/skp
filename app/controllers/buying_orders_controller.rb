class BuyingOrdersController < ApplicationController

  protect_from_forgery :only => [:create, :update, :destroy]

  def index 
    
    @pending_input_orders = []
    temp = InputOrder.find(:all, :conditions=>"status like 'pendiente' and id != #{current_input_order}")
    temp.each do |t|
      @pending_input_orders << t unless t.childless?
    end
    
    session[:age_from] = 0
    session[:age_to] = 18
        
    
    @input_order_detail = InputOrderDetail.new
    @price = Price.new
    @products = ""
    @input_orders = ""

    begin    
      @input_order =  session[:input_order_id] ?  InputOrder.find(session[:input_order_id])  : InputOrder.new
      @input_order.order_date ||= Time.zone.now
      @input_order_details = @input_order.input_order_details
    rescue Exception => ex
      RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                 
      @input_order = InputOrder.new
      @input_order_details = @input_order.input_order_details
      
    end
  end


  def recover
    
    @input_order = InputOrder.find(params[:id])
    
    if @input_order.status == "terminada"
  
      @input_order.input_order_details.each do |iod|

      unless iod.product.nil?

        if @input_order.unload_stock or @input_order.unload_stock.nil?
          iod.product.update_stock(-iod.quantity)
          iod.product.update_store_stock(-iod.quantity, @input_order.store_id)
          iod.product.status = "open"
          iod.product.save!
        
          #iod.product.unload_if_pending
          #iod.product.save!
        end
      end  #no es nulo

    end  #each_do
  end # terminada
    
    @input_order.status = "pendiente"
    @input_order.save
    session[:input_order_id] = params[:id]
    redirect_to input_orders_path
  end


  def auto_complete_for_input_order
    @products = Product.search('"*' + params["q"]+'*"', :limit=> 7, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        

    #@products = Product.find_all_by_codes("*" + params["q"]+"*", {:limit => 7 })  #CHANGE THIS
    # @products = @products.to_json
    # render :partial => "search_results", :layout=>false 
  end


  def update
    create
  end 


  def update_order

    InputOrder.transaction do 
      @input_order = InputOrder.find(current_input_order)
      @input_order.provider_id = params[:order][:provider]
      @input_order.document = params[:order][:document]
      
      year = params[:order][:order_date]['year'] 
      month = params[:order][:order_date]['month'] 
      day = params[:order][:order_date]['day']
      @input_order.order_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @input_order.store_id = params[:order][:store_id]
      @input_order.owner_id = params[:order][:owner_id]
      @input_order.status = "pendiente"
      if @input_order.save

        render :text=>"Todo bien"

      else

        render :text=>"Error en los datos"
      end

    end #fin de transaccion
  end 

  def clean_form

    params[:input_order_detail][:hidden_product_id] = ""
    params[:input_order_detail][:cost] = ""
    params[:input_order_detail][:quantity] = "" 
    params[:price][:amount] = ""
    params[:input_order][:boxed_price] = ""
    params[:input_order][:wholesale_price] = ""
    params[:input_order][:final_price] = ""     


  end 


  def save_prices(iod)

    #Create four Prices
    Price.transaction do 
      base_price = Price.new
      base_price.product_id = iod.product_id
      base_price.input_order_detail_id = iod.id
      base_price.amount = params[:price][:amount]
      base_price.description = "Precio base"
      base_price.discount = 0
      base_price.save!       
    end
             
    Price.transaction do
      boxed_price = Price.new
      boxed_price.product_id = iod.product_id
      boxed_price.input_order_detail_id = iod.id
      boxed_price.amount = params[:input_order][:boxed_price]
      boxed_price.description = "Precio en caja"
      boxed_price.discount = 0
      boxed_price.save!

    end

    Price.transaction do
      wholesale_price = Price.new      
      wholesale_price.product_id = iod.product_id
      wholesale_price.input_order_detail_id = iod.id
      wholesale_price.amount = params[:input_order][:wholesale_price]
      wholesale_price.description = "Precio mayorista"
      wholesale_price.discount = 0
      wholesale_price.save!      
      p = iod.product
      p.corporative_price = params[:input_order][:wholesale_price]
      p.save
    end

    Price.transaction do
      final_price = Price.new
      final_price.product_id = iod.product_id
      final_price.input_order_detail_id = iod.id
      final_price.amount = params[:input_order][:final_price]
      final_price.description = "Precio Tienda 1"
      final_price.discount = 0
      final_price.save!
    end

    Price.transaction do
      final_price_polo = Price.new
      final_price_polo.product_id = iod.product_id
      final_price_polo.input_order_detail_id = iod.id
      final_price_polo.amount = params[:input_order][:final_price_polo]
      final_price_polo.description = "Precio Tienda 2"      
      final_price_polo.discount = 0
      final_price_polo.save!
    end
  
  end

  def add_product


   begin

      InputOrderDetail.transaction do 

        @iod = InputOrderDetail.new
        @iod.input_order_id = current_input_order
        @iod.product_id = params[:input_order_detail][:hidden_product_id]
        @iod.cost = params[:input_order_detail][:cost].to_f
        @iod.quantity = params[:input_order_detail][:quantity]  
        @iod.additional_code = params[:input_order_detail][:additional_code]
        @input_order = @iod.input_order
        @input_order.cost += @iod.cost.to_f * @iod.quantity
        @input_order.save


        @iod.save! 

        save_prices(@iod) if admin?


      end  #fin de transacción

      respond_to do |wants|

        wants.js { 

          render :update do |page|

            @input_order_details = @iod.input_order.input_order_details

            page.replace 'detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'product_table'            
            page.visual_effect :fade, 'product_error'
            page.call('clean_forms')            
            page.replace_html 'product_error', ""                                    
            #clean_form            
          end

        }

      end  # respond_to


#=begin
    rescue Exception=> ex

      respond_to do |wants|

        wants.js {

          render :update do |page|      
            RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")           
            page.visual_effect :show, 'product_error'    
            page.visual_effect :highlight, 'product_error'                
            page.replace_html 'product_error',"<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos.</em>"
            page.visual_effect :highlight, 'new_product_error'             

          end

        }

      end

    end
#=end    

  end



  def create

     

    InputOrder.transaction do 

      

      @input_order = InputOrder.find(current_input_order)
      
      @input_order.restore
      
      year = params[:input_order]["order_date(1i)"] 
      month = params[:input_order]["order_date(2i)"] 
      day = params[:input_order]["order_date(3i)"]
      @input_order.order_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @input_order.provider_id = params[:input_order][:provider_id]
      @input_order.store_id = params[:input_order][:store_id]
      @input_order.owner_id = params[:input_order][:owner_id]
      @input_order.document = params[:input_order][:document]
      if (not params[:input_order_detail][:hidden_product_id].empty?) && (not params[:input_order_detail][:cost].empty?) &&  (not params[:input_order_detail][:quantity].empty?)
        @iod = InputOrderDetail.new
        @iod.product_id = params[:input_order_detail][:hidden_product_id].to_i
        @iod.cost = params[:input_order_detail][:cost].to_f
        @iod.quantity = params[:input_order_detail][:quantity].to_i
        @iod.additional_code = params[:input_order_detail][:additional_code]              
        @iod.input_order_id = current_input_order
        @iod.save!
        save_prices(@iod)
      end

      @input_order.cost = @input_order.input_order_details.inject(0){| sum, iod | sum + (iod.cost.to_f*iod.quantity)  }


      if @input_order.valid?
        @input_order.save!




        if @input_order.input_order_details.empty?

          flash[:error]="<em>No ha ingresado ningún producto</em>"
          @input_order_details =  []
          render :action=>:index
        else

          @input_order.input_order_details.each do |iod|

            unless iod.product.nil?

              if @input_order.unload_stock or @input_order.unload_stock.nil?
                iod.product.update_stock(iod.quantity)
                iod.product.update_store_stock(iod.quantity, @input_order.store_id)
                iod.product.status = "terminada"
                iod.product.save!
              
                iod.product.unload_if_pending
                iod.product.save!
              end
            end  #no es nulo

          end  #each_do

          @input_order.status = "terminada"
          @input_order.save!


        session[:input_order_id] = nil         
        flash[:message] = "<em>Ingreso realizado exitosamente. <a href='/input_orders'>Agregar uno nuevo</a></em>"


          redirect_to input_order_report_path(@input_order.id)
        end   #lista vacia de productos

      else
        flash[:error]="<em>Error en la orden</em>"
        render :action=>:index
      end  #es valido

    end #  fin transaccione

  end

  def last_input_orders
    p = Product.find(params[:input_order][:product_id])
    @input_orders = p.last_input_orders
  end

  def destroy
    
    InputOrder.transaction do
      
      @input_order = InputOrder.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
                                                   #como la orden AÚN no se ha terminado, el stock no se toca pero si los precios
          
      @input_order.restore
                                               
        @input_order.input_order_details.each do |iod|
          
            iod.prices.each do |p|                  #eliminamos todos los precios asociados
              p.destroy
            end
            
            iod.destroy                             #eliminamos el detalle orden
          
        end
      
      
      @input_order.destroy                          #finalmente eliminamos la orden
      
      last_order =     @pending_input_orders = InputOrder.find(:all, :conditions=>"status like 'pendiente' and id != #{current_input_order} and store_id=#{get_current_store}", :order=>'created_at DESC', :limit=>1)
      session[:input_order_id] = last_order.id
      
          redirect_to input_orders_path
      
      
    end
    
  end


  def destroyDetail
    @input_order_detail = InputOrderDetail.find(params[:id])
    @input_order_detail.input_order.cost -= @input_order_detail.cost.to_f * @input_order_detail.quantity
    
    
    
    @input_order_detail.input_order.save
    @input_order_detail.destroy
    @input_order = InputOrder.find(current_input_order)
    respond_to do |format|
      format.js  { 
        render :update do |page|
          @input_order_details = @input_order.input_order_details           
          page.replace 'detalle', :partial => 'product_list'
          page.visual_effect :highlight, 'product_table'            
          page.visual_effect :fade, 'product_error'
          page.call('clean_forms')
          page.replace_html 'product_error', ""

        end

      }
    end

  end


end
