class ExitOrdersController < ApplicationController
  # GET /exit_orders
  # GET /exit_orders.xml
  
  before_filter :check_pending, :only=>[:index]

  def check_pending
    
    #Gets the current opened InputOrders (created by other users and whatnot)
    @pending_exit_orders = ExitOrder.get_pending_of current_exit_order
  
  end
  
  def index

    @exit_order = session[:exit_order_id] ? ExitOrder.find(session[:exit_order_id])  : ExitOrder.new
    @exit_order.store_id = get_current_store
    @exit_order.unload_stock ||= true
    @exit_order.price ||= 0
    @exit_order.sending_date = Time.zone.now
    @exit_order.document ||= ExitOrder.last_number_of(get_current_store)
    @exit_order_detail = ExitOrderDetail.new
    @exit_order_details = session[:exit_order_id] ? ExitOrder.find(session[:exit_order_id]).exit_order_details  : []

  end
  
  def return_stock
    
    ExitOrder.transaction do 
    @exit_order = ExitOrder.find(params[:id])
    
    if @exit_order.unload_stock or @exit_order.unload_stock.nil?
      @exit_order.exit_order_details.each do |sgd|
      
          sgd.product.update_store_stock(sgd.quantity,@exit_order.store_id)
          sgd.product.update_stock(sgd.quantity)
      end
    end
          
    @exit_order.status = "returned"
    @exit_order.save
    
    flash[:message]="<em>Stock ingresado de vuelta</em>"
    redirect_to exit_orders_report_path
    
    end #transaction
    
  end

  def recover

    @exit_order = ExitOrder.find(params[:id])


    if @exit_order.status == "accepted"
      if @exit_order.unload_stock or @exit_order.unload_stock.nil?
         @exit_order.exit_order_details.each do |sgd|

              sgd.product.update_store_stock(sgd.quantity,@exit_order.store_id)
              sgd.product.update_stock(sgd.quantity)
         end
       end #unload_stock
    end # accepted
    
    @exit_order.status = "pending"
    @exit_order.save
     session[:exit_order_id] = params[:id]
     redirect_to exit_orders_path
   end


  def current_exit_order

    if not session[:exit_order_id] or not ExitOrder.exists?(session[:exit_order_id])

      @exit_order = ExitOrder.new      
      @exit_order.store_id = get_current_store
      
       if params[:exit_order]
        @exit_order.client_id = params[:exit_order][:hidden_client_id]
        @exit_order.document = ExitOrder.last_number_of(get_current_store)      
      else
        @exit_order.client_id = 1
      end
    
      @exit_order.sending_date = Time.zone.now
      @exit_order.unload_stock = true
      @exit_order.status ="pending"
      @exit_order.save!
      session[:exit_order_id] = @exit_order.id

    end

    return session[:exit_order_id]

  end


  def add_product

    @sod = ExitOrderDetail.new
    @sod.exit_order_id = current_exit_order
    @sod.status = "open"
    @sod.product_id = params[:exit_order_detail][:hidden_product_id]
    @sod.quantity = params[:exit_order_detail][:quantity]
    
    @sod.price = params[:exit_order_detail][:price]    
    @sod.quantity = params[:exit_order_detail][:quantity]
    @sod.discount = params[:exit_order_detail][:discount] || 0
    error = ""
    begin 
      

      if @sod.quantity > @sod.product.store_stock(get_current_store)
        error = "<em id='new_product_error'>No hay stock suficiente</em>"
        raise "No hay stock suficiente"
      end

      @exit_order = ExitOrder.find(current_exit_order)
      if @exit_order.exit_order_details.size >= 26
        error = "<em id='new_product_error'>Ya tiene 25 items agregados</em>"
        raise "Limite de Items"
      end


      
      if @sod.save!
          @exit_order = @sod.exit_order
          price = @sod.discount.nil? ? @sod.price*@sod.quantity : (@sod.price*(1.0-@sod.discount/100.0)) * @sod.quantity
          @exit_order.price ||= 0
      
          @exit_order.price += price
          @exit_order.save!


        respond_to do |wants|

          wants.js { 

            render :update do |page|

              @exit_order_details = @exit_order.exit_order_details

              page.replace 'detalle', :partial => 'product_list'
              page.visual_effect :highlight, 'product_table'            
              page.visual_effect :fade, 'product_error'
              page.call('clean_forms')
              page << "$('#exit_order_detail_product_id').focus();"              
              page.replace_html 'product_error', ""                                    
              #clean_form            
            end

          }

        end



      end

    rescue Exception => ex

      respond_to do |wants|

        wants.js {

          render :update do |page|            
            if error == ""
            error = "<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos: #{@sod.errors.each do |e| e end }.</em>"
          end
                 
            page.visual_effect :show, 'product_error'    
            page.replace_html 'product_error', error
            RAILS_DEFAULT_LOGGER.error("\n #{debug(@sod.errors) +  ex}  \n")
            page.visual_effect :highlight, 'new_product_error'             
          end

        }

      end

    end


  end

  def update_exit_order
    
    ExitOrder.transaction do 
      @exit_order = ExitOrder.find(current_exit_order)
      @exit_order.document = params[:exit_order][:document]
      
      year = params[:exit_order][:sending_date]['year'] 
      month = params[:exit_order][:sending_date]['month'] 
      day = params[:exit_order][:sending_date]['day']
      @exit_order.sending_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @exit_order.client_id = params[:exit_order][:store_id]
      @exit_order.driver_name = params[:exit_order][:driver_name]
      @exit_order.driver_dni = params[:exit_order][:driver_dni]
      @exit_order.extra_data = params[:exit_order][:extra_data]      
      @exit_order.status = "pendiente"
      if @exit_order.save

        render :text=>"Todo bien"

      else

        render :text=>"Error en los datos"
      end

    end #fin de transaccion
    
  end

  def update
    create
  end

  def create

    ExitOrder.transaction do 

      @exit_order = ExitOrder.find(current_exit_order)

      @exit_order.restore

      year = params[:exit_order]["sending_date(1i)"] 
      month = params[:exit_order]["sending_date(2i)"] 
      day = params[:exit_order]["sending_date(3i)"]
      @exit_order.sending_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @exit_order.store_id = get_current_store
      @exit_order.client_id = params[:exit_order][:hidden_client_id]
      @exit_order.client_id ||= params[:exit_order][:client_id] 
      @exit_order.address = params[:exit_order][:address]
      @exit_order.driver_name = params[:exit_order][:driver_name]
      @exit_order.driver_dni = params[:exit_order][:driver_dni] 
      @exit_order.extra_data = params[:exit_order][:extra_data] 
      
      @exit_order.document = params[:exit_order][:document]


      if @exit_order.valid?
        @exit_order.save!



        if (not params[:exit_order_detail][:hidden_product_id].empty?) && (not params[:exit_order_detail][:quantity].empty?)
          @sod = ExitOrderDetail.new
          @sod.product_id = params[:exit_order_detail][:hidden_product_id].to_i
          @sod.quantity = params[:exit_order_detail][:quantity].to_i
          @sod.exit_order_id = current_exit_order
          @sod.save!
        end


        if @exit_order.exit_order_details.empty?

          flash[:error]="<em>No ha ingresado ningún producto</em>"
          @exit_order_details =  []
          render :action=>:index
        else

          @exit_order.exit_order_details.each do |sod|

            if @exit_order.unload_stock
              sod.product.update_stock(sod.quantity*-1) unless sod.product.nil?
              sod.product.update_store_stock(sod.quantity*-1,@exit_order.store_id) unless sod.product.nil?
            end
          end

          @exit_order.status ="accepted"
          @exit_order.save!
          session[:exit_order_id] = nil         
          flash[:message] = "<em>Orden de Salida registrada exitosamente. <a href='/sending'>Generar una nueva</a></em>"


          redirect_to exit_order_report_path(@exit_order.id)
        end
      else
          redirect_to exit_orders_path
        flash[:error]="<em>Error en la orden</em>"
        render :action=>:index
      end

    end

  end

    def auto_complete_for_order
      #CHANGE THIS
      @clients = Client.search  '"*' + params["q"] + '*"', :limit => 10 #:conditions=>"status NOT LIKE 'pendiente'", 

  #    @clients = Client.find_all_by_name("*" + params["q"]+"*", {:limit => 10})
      # @products = @products.to_json
      # render :partial => "search_results", :layout=>false 
    end

    def auto_complete_for_input_order
      #CHANGE THIS
      @products = Product.search( '"*' + params[:exit_order_detail][:product_code] + '*"' ).first
      #@products = Product.search('"*' + params["q"]+'*"', :limit=> 7, :conditions=>{'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
      # @products = @products.to_json
      # render :partial => "search_results", :layout=>false 
    end
    
    

  def destroyDetail
    @exit_order_detail = ExitOrderDetail.find(params[:id])
    @exit_order = @exit_order_detail.exit_order
   
    price = @exit_order_detail.discount.nil? ? @exit_order_detail.price*@exit_order_detail.quantity : (@exit_order_detail.price*(1.0-@exit_order_detail.discount/100.0)) * @exit_order_detail.quantity
   
    @exit_order.price -= price
    @exit_order.save
      
    @exit_order_detail.destroy
    @exit_order = ExitOrder.find(current_exit_order)
    respond_to do |format|
      format.js  { 
        render :update do |page|
          @exit_order_details = @exit_order.exit_order_details           
          page.replace 'detalle', :partial => 'product_list'
          page.visual_effect :highlight, 'product_table'            
          page.visual_effect :fade, 'product_error'
          page.call('clean_forms')
          page.replace_html 'product_error', ""

        end

      }
    end

  end
  
  def create_order
    
    begin
      @credit_cards = ["VISA","Mastercard"]
      @order_details = []
    Order.transaction do
      @exit_order = ExitOrder.find(params[:id])   #obtenemos la guia y creamos una factura en base a ésta
      @order = Order.new     
      @order.exit_order_id = @exit_order.id
      @order.type = "factura"
      @order.order_date = Time.zone.now
      @order.client = @exit_order.client
      @order.store = @exit_order.store
      @order.address = @exit_order.client.address
      @order.number = Order.last_number_of(@order.type,get_current_store)
      @order.status = "open"
      @order.unload_stock = false       
      @exit_order.exit_order_details.pending.reverse.each do |sgd|   #cada detalle del orden de envio que no se haya procesado
                                                                   #se pasa a uno de factura
      price = sgd.price

      test_price = sgd.product.current_prices(true,get_current_store)[1]
      price ||= test_price.nil? ? 0.0 : test_price.amount
        
        od = OrderDetail.new({:product_id=>sgd.product_id,
                                    :quantity=>sgd.pending,
                                    :price => price,
                                    :discount=>0.0,
                                    :exit_order_detail_id=>sgd.id,
                                  })
        #od.save!
        
        @order_details << od


      end
      
      @order.price = @order_details.inject(0){| sum, od | sum + (od.price.to_f*od.quantity)  }
    end

    rescue Exception => ex
      RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                       
  #    RAILS_DEFAULT_LOGGER.error("\n #{ od.errors }  \n")                             
    end
    
  end
  
  def generate_order
    Order.transaction do 
      
    @exit_order = ExitOrder.find(params[:id])
    @order = Order.new(params[:exit_order])
    @order.type = "factura"
    @order.client = @exit_order.client
    @order.exit_order_id = @exit_order.id
    @order.address = @exit_order.client.address
    @order.store_id = @exit_order.store
    @order.status = "accepted"
    @order.unload_stock = false
    @order.save!
    
    OrderDetail.create(params[:exit_order_details]) do |od| 
      od.order_id = @order.id
      od.save
      sgd = od.exit_order_detail
      sgd.pending = sgd.quantity if sgd.pending.nil?
      sgd.pending -= od.quantity
      sgd.status = "postponed"
      sgd.status = "processed" if sgd.pending.zero?
      sgd.save!
    end
    
    @order.price = @order.order_details.inject(0){| sum, od | sum + (od.price.to_f*od.quantity)  }
    @order.save!
    
    if @exit_order.exit_order_details.postponed.empty?
        @exit_order.status = "complete"
        @exit_order.save!
        redirect_to order_report_path(@order.id)
    else
        @exit_order.exit_order_details.postponed.each do |sgd|
          sgd.status = "open"
          sgd.save!
        end
        redirect_to order_from_guide_path(@exit_order.id)
    end

  end
    
  end


  def destroyOrderDetail
     counter = params[:counter].to_i
     inner_count = 0
     @exit_order = ExitOrder.find(params[:exit_order])
     @order = Order.new
     @order_details = []
     @exit_order.exit_order_details.pending.reverse.each do |sgd|   # cada detalle del orden de envio que no se haya procesado
                                                                  # se pasa a uno de factura
      price = sgd.price
      test_price = sgd.product.current_prices(true,get_current_store)[1]  


                    od = OrderDetail.new({:product_id=>sgd.product_id,
                                          :quantity=>sgd.pending,
                                             :price => price,
                                          :discount=>0.0,
                                          :exit_order_detail_id=>sgd.id
                                     })
        unless counter == inner_count
           @order_details << od
         else
            sgd.status = "postponed"
            sgd.save!
         end
         
         inner_count +=1
         
         end
     @order.price = @order_details.inject(0){| sum, od | sum + (od.price.to_f*od.quantity)  }
     respond_to do |format|
       format.js  { 
         render :update do |page|
           page.replace 'detalle', :partial => 'temporal_product_list'
           page.visual_effect :highlight, 'product_table'            
           page.visual_effect :fade, 'product_error'
           page.call('clean_forms')
           page.replace_html 'product_error', ""

         end

       }
     end

   end


end