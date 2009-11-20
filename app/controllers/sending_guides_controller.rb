class SendingGuidesController < ApplicationController
  # GET /sending_guides
  # GET /sending_guides.xml
  
  before_filter :no_cache
  
  
  def index

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.sending_type = ""
    @sending_guide.store_id ||= get_current_store
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []


  end
  
  def perdida

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.sending_type = "perdida"    
    @sending_guide.store_id ||= get_current_store    
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []

    render :action => "index"
  end


  def devolucion

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.sending_type = "devolucion"    
    @sending_guide.store_id ||= get_current_store    
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []

    render :action => "index"
  end


  def mal_estado

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.sending_type = "mal-estado"    
    @sending_guide.store_id ||= get_current_store    
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []

    render :action => "index"
  end

  def consumo_interno

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.store_id ||= get_current_store    
    @sending_guide.sending_type = "consumo-interno"
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []

    render :action => "index"
  end

  def consumo_externo

    @sending_guide = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id])  : SendingGuide.new
    @sending_guide.unload_stock ||= true
    @sending_guide.store_id ||= get_current_store    
    @sending_guide.sending_type = "consumo-externo"
    @sending_guide_detail = SendingGuideDetail.new
    @sending_guide_details = session[:sending_guide_id] ? SendingGuide.find(session[:sending_guide_id]).sending_guide_details  : []

    render :action => "index"
  end
  
  
  def return_stock
    
    SendingGuide.transaction do 
    @sending_guide = SendingGuide.find(params[:id])
    
    unless @sending_guide.unload_stock    
      @sending_guide.sending_guide_details.each do |sgd|
      
          sgd.product.update_store_stock(sgd.quantity,@sending_guide.store_id,self.class,this_method_name)
          sgd.product.update_stock(sgd.quantity)
      end
    end
          
    @sending_guide.status = "returned"
    @sending_guide.save
    
    flash[:message]="<em>Stock ingresado de vuelta</em>"
    redirect_to sending_guides_report_path
    
    end #transaction
    
  end

  def recover

    @sending_guide = SendingGuide.find(params[:id])


    if @sending_guide.status == "accepted"
      unless @sending_guide.unload_stock
         @sending_guide.sending_guide_details.each do |sgd|

              sgd.product.update_store_stock(sgd.quantity,@sending_guide.store_id,self.class,this_method_name)
              sgd.product.update_stock(sgd.quantity)
         end
       end
    end
    @sending_guide.status = "pending"
     session[:sending_guide_id] = params[:id]
     redirect_to sending_guides_path
   end


  def current_sending_guide

    if not session[:sending_guide_id] or not SendingGuide.exists?(session[:sending_guide_id])

      @sending_guide = SendingGuide.new      
      @sending_guide.store_id = params[:sending_guide][:store_id]
      @sending_guide.client_id = params[:sending_guide][:hidden_client_id]
      @sending_guide.sending_date = Time.zone.now
      @sending_guide.unload_stock = true
      @sending_guide.status ="pending"
      @sending_guide.store_id ||= get_current_store      
      @sending_guide.save!
      session[:sending_guide_id] = @sending_guide.id

    end

    return session[:sending_guide_id]

  end


  def add_product

    @sod = SendingGuideDetail.new
    @sod.sending_guide_id = current_sending_guide
    @sod.status = "open"
    @sod.product_id = params[:sending_guide_detail][:hidden_product_id]
    @sod.quantity = params[:sending_guide_detail][:quantity]
    error = ""
    begin 
      
      if @sod.quantity > @sod.product.store_stock(get_current_store)
        error = "<em id='new_product_error'>No hay stock suficiente</em>"
        raise "No hay stock suficiente"
      end

      if @sod.save!

        respond_to do |wants|

          wants.js { 

            render :update do |page|

              @sending_guide_details = @sod.sending_guide.sending_guide_details

              page.replace 'detalle', :partial => 'product_list'
              page.visual_effect :highlight, 'product_table'            
              page.visual_effect :fade, 'product_error'
              page.call('clean_forms')
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

  def update
    create
  end

  def create

    SendingGuide.transaction do 

      @sending_guide = SendingGuide.find(current_sending_guide)

      year = params[:sending_guide]["sending_date(1i)"] 
      month = params[:sending_guide]["sending_date(2i)"] 
      day = params[:sending_guide]["sending_date(3i)"]
      @sending_guide.sending_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @sending_guide.store_id = params[:sending_guide][:store_id]
      @sending_guide.client_id = params[:sending_guide][:hidden_client_id]
      @sending_guide.client_id ||= params[:sending_guide][:client_id] 
      @sending_guide.delivery_address = params[:sending_guide][:delivery_address]
      @sending_guide.delivery_contact = params[:sending_guide][:delivery_contact]
      @sending_guide.delivery_phone = params[:sending_guide][:delivery_phone]  
      @sending_guide.sending_type = params[:sending_guide][:sending_type]
      #  delivery_address  :string(255)
      #  delivery_contact  :string(255)
      #  delivery_phone    :string(255)
      
      
      @sending_guide.driver_name = params[:sending_guide][:driver_name]
      @sending_guide.license_plate = params[:sending_guide][:license_plate]
      @sending_guide.document = params[:sending_guide][:document]
      @sending_guide.truck_description = params[:sending_guide][:truck_description]


      if @sending_guide.valid?
        @sending_guide.save!



        if (not params[:sending_guide_detail][:hidden_product_id].empty?) && (not params[:sending_guide_detail][:quantity].empty?)
          @sod = SendingGuideDetail.new
          @sod.product_id = params[:sending_guide_detail][:hidden_product_id].to_i
          @sod.quantity = params[:sending_guide_detail][:quantity].to_i
          @sod.sending_guide_id = current_sending_guide
          @sod.save!
        end


        if @sending_guide.sending_guide_details.empty?

          flash[:error]="<em>No ha ingresado ningún producto</em>"
          @sending_guide_details =  []
          render :action=>:index
        else

          @sending_guide.sending_guide_details.each do |sod|

            if @sending_guide.unload_stock
              sod.product.update_stock(sod.quantity*-1) unless sod.product.nil?
              sod.product.update_store_stock(sod.quantity*-1,@sending_guide.store_id,self.class,this_method_name) unless sod.product.nil?
            end
          end

          @sending_guide.status ="accepted"
          @sending_guide.save!
          session[:sending_guide_id] = nil         
          flash[:message] = "<em>Orden de Salida a Cliente registrada exitosamente. <a href='/sending'>Generar una nueva</a></em>"


          redirect_to sending_guide_report_path(@sending_guide.id  )
        end
      else
          redirect_to sending_guides_path
        flash[:error]="<em>Error en la orden</em>"
        render :action=>:index
      end

    end

  end

  def destroyDetail
    @sending_guide_detail = SendingGuideDetail.find(params[:id])
    @sending_guide_detail.destroy
    @sending_guide = SendingGuide.find(current_sending_guide)
    respond_to do |format|
      format.js  { 
        render :update do |page|
          @sending_guide_details = @sending_guide.sending_guide_details           
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
      @sending_guide = SendingGuide.find(params[:id])   #obtenemos la guia y creamos una factura en base a ésta
      @order = Order.new     
      @order.sending_guide_id = @sending_guide.id
      @order.type = "factura"
      @order.order_date = Time.zone.now
      @order.client = @sending_guide.client
      @order.store = @sending_guide.store
      @order.address = @sending_guide.client.address
      @order.number = Order.last_number_of(@order.type,get_current_store)
      @order.status = "open"
      @order.unload_stock = false       
      @sending_guide.sending_guide_details.pending.reverse.each do |sgd|   #cada detalle del orden de envio que no se haya procesado
                                                                   #se pasa a uno de factura
      price = sgd.price

      test_price = sgd.product.current_prices(true,get_current_store)[1]
      price ||= test_price.nil? ? 0.0 : test_price.amount
        
        od = OrderDetail.new({:product_id=>sgd.product_id,
                                    :quantity=>sgd.pending,
                                    :price => price,
                                    :discount=>0.0,
                                    :sending_guide_detail_id=>sgd.id,
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
      
    @sending_guide = SendingGuide.find(params[:id])
    @order = Order.new(params[:order])
    @order.type = "factura"
    @order.client = @sending_guide.client
    @order.sending_guide_id = @sending_guide.id
    @order.address = @sending_guide.client.address
    @order.store_id = @sending_guide.store
    @order.status = "accepted"
    @order.unload_stock = false
    @order.save!
    
    OrderDetail.create(params[:order_details]) do |od| 
      od.order_id = @order.id
      od.save
      sgd = od.sending_guide_detail
      sgd.pending = sgd.quantity if sgd.pending.nil?
      sgd.pending -= od.quantity
      sgd.status = "postponed"
      sgd.status = "processed" if sgd.pending.zero?
      sgd.save!
    end
    
    @order.price = @order.order_details.inject(0){| sum, od | sum + (od.price.to_f*od.quantity)  }
    @order.save!
    
    if @sending_guide.sending_guide_details.postponed.empty?
        @sending_guide.status = "complete"
        @sending_guide.save!
        redirect_to order_report_path(@order.id)
    else
        @sending_guide.sending_guide_details.postponed.each do |sgd|
          sgd.status = "open"
          sgd.save!
        end
        redirect_to order_from_guide_path(@sending_guide.id)
    end

  end
    
  end


  def destroyOrderDetail
     counter = params[:counter].to_i
     inner_count = 0
     @sending_guide = SendingGuide.find(params[:sending_guide])
     @order = Order.new
     @order_details = []
     @sending_guide.sending_guide_details.pending.reverse.each do |sgd|   # cada detalle del orden de envio que no se haya procesado
                                                                  # se pasa a uno de factura
      price = sgd.price
      test_price = sgd.product.current_prices(true,get_current_store)[1]  


                    od = OrderDetail.new({:product_id=>sgd.product_id,
                                          :quantity=>sgd.pending,
                                             :price => price,
                                          :discount=>0.0,
                                          :sending_guide_detail_id=>sgd.id
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