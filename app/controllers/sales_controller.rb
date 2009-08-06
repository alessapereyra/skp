class SalesController < ApplicationController

  def index
    
    @pending_orders = []
    temp = Order.find(:all, :conditions=>"status like 'open' and id != #{current_order} and store_id=#{get_current_store}")
    temp.each do |t|
      @pending_orders << t unless t.childless?
    end
    
    @order_detail = OrderDetail.new
    @credit_cards = ["Efectivo","Diferido","VISA","Mastercard"]
    
    begin
    
      @order = session[:order_id] ? Order.find(session[:order_id]) : Order.new  
      unless @order.store_id.blank?
        if @order.store_id != get_current_store
          @order.number = Order.last_number_of(@order.type,get_current_store)   
        end
      end
      
      @order.store_id = get_current_store
      @order.price = @order.price || 0
      @order.order_date ||= Time.zone.now
      @order.type ||= "boleta"
      @order.number ||= Order.last_number_of(@order.type,get_current_store)
      @order_details = !@order.order_details.nil? ? @order.order_details  : []
    
    rescue

      @order = Order.new  
      @order.number = Order.last_number_of("boleta",get_current_store)
      @order.store_id = get_current_store
      @order.price = @order.price || 0
      @order.type = "boleta"
      @order_details = !@order.order_details.nil? ? @order.order_details  : []

    
    end
  end



  def last_order_number
    session[:last_order_number]
  end

  def current_order

    if not session[:order_id] or not Order.exists?(session[:order_id])

      @order = Order.new      
      @order.store_id = get_current_store
      if params[:order]
      @order.client_id = params[:order][:hidden_client_id]
      @order.type = params[:order][:type] || "boleta"
      @order.number = Order.last_number_of(@order.type,get_current_store)      
      else
        @order.client_id = 1
        @order.type =  "boleta"
      end    
      @order.number = Order.last_number_of(@order.type,get_current_store)      
      @order.order_date = Time.zone.now
      @order.status = "open"
      @order.unload_stock = true
      @order.price = 0 
      @order.save!
      session[:order_id] = @order.id

    end

    return session[:order_id]

  end

  def add_product

    @od = OrderDetail.new
    @order = Order.find(current_order)
    @od.order = @order

    @od.product_id = Product.find(params[:order_detail][:hidden_product_id]).id



    @od.price = params[:order_detail][:price]    
    @od.quantity = params[:order_detail][:quantity]
    @od.discount = params[:order_detail][:discount] || 0
    @order.unload_stock = params[:order][:unload_stock]

     begin 
        
        if @order.unload_stock or @order.unload_stock.nil?
          if @od.quantity > Product.find(@od.product_id).store_stock(get_current_store)
              error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
              raise "No hay stock suficiente"
            end
        end
        
          Order.transaction do  
        
        
        if @od.save!
          price = @od.discount.nil? ? @od.price.to_f*@od.quantity.to_f : (@od.price*(1.0-@od.discount/100.0)) * @od.quantity.to_f
          @order.price += price
          @order.save!



          respond_to do |wants|

            wants.js { 

              render :update do |page|

                @order_details = @od.order.order_details

                page.replace 'detalle', :partial => 'product_list'
                page.visual_effect :highlight, 'product_table'            
                page.visual_effect :fade, 'product_error'
                page.call('clean_forms')
                page.replace_html 'product_error', ""                                    
                #clean_form            
              end

            }

          end



        end   # if @od.save!
        
        end  #transaccion
#=begin
      end  #begin
    rescue Exception => ex

      respond_to do |wants|

        wants.js {

          render :update do |page|                 
            RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                       
            page.visual_effect :show, 'product_error'    
            page.replace_html 'product_error', error || "<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos.</em>"
            page.visual_effect :highlight, 'new_product_error'             
            
          end

        }

      end
#=end


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
    @products = Product.search( '"*' + params[:order_detail][:product_code] + '*"' ).first
    #@products = Product.search('"*' + params["q"]+'*"', :limit=> 7, :conditions=>{'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
    # @products = @products.to_json
    # render :partial => "search_results", :layout=>false 
  end


  def product_price
    Product.find(params[:order_detail][:product_id])
  end

  def product_prices
    user = User.find_by_username(session[:logged_user])
    admin = (user.store_supervisor? or user.admin? or user.store_admin?)
    @prices = Product.find(params[:product_id]).current_prices(admin,get_current_store)
    render :text => @prices.to_json, :layout=>false
  end

  def all_product_prices
    @prices = []
    @prices << Product.find(params[:id]).input_order_details.last.cost
    @prices << Product.find(params[:id]).all_current_prices

    render :text => @prices.to_json, :layout=>false
  end


  def update
    create
  end

  def create 
    
    Order.transaction do 
    @order = Order.find(current_order)
    
    @order.restore
    
    year = params[:order]["order_date(1i)"] 
    month = params[:order]["order_date(2i)"] 
    day = params[:order]["order_date(3i)"]
    @order.order_date = Time.zone.parse("#{year}-#{month}-#{day}")
    @order.store_id = get_current_store
    
    
    @order.client_id = params[:order][:hidden_client_id] 
    @order.client_id ||= params[:order][:client_id] 
    @order.type  = params[:order][:type] || "boleta"
    @order.address = @order.client.address unless @order.client.nil?
    @order.number = params[:order][:number] || Order.last_number_of(@order.type,get_current_store)
    @order.credit_card = params[:order][:credit_card]

    if @order.valid?
      @order.save!



      if (not params[:order_detail][:hidden_product_id].empty?) &&
        (not params[:order_detail][:quantity].empty?) && 
        (not params[:order_detail][:price].empty?)
        @od = OrderDetail.new
        @od.product_id = params[:order_detail][:hidden_product_id].to_i
        @od.quantity = params[:order_detail][:quantity].to_i
        @od.price =  params[:order_detail][:price].to_i
        @od.discount = params[:order_detail][:discount] || 0                 
                      
        @od.order = @order
        @od.save!
        
        price = @od.discount.nil? ? @od.price*@od.quantity : (@od.price*(1.0-@od.discount/100.0)) * @od.quantity
        @order.price += price
        
        
#        @order.price += (@od.price*(1.0-@od.discount/100.0)) * @od.quantity
        @order.save!                   
      end  # ultima insercion


      if @order.order_details.empty?

        flash[:error]="<em>No ha ingresado ningún producto</em>"
        @order_details =  []
        @credit_cards = ["VISA","Mastercard"] 
        render :action=>:index
      else
        @order.status = "accepted"
        @order.save!
        @order.order_details.each do |sod|

          if @order.type == "nota_de_credito"
            sod.product.update_stock(sod.quantity) unless sod.product.nil?
            sod.product.update_store_stock(sod.quantity,@order.store_id,self.class,this_method_name) unless sod.product.nil?
            sod.product.unload_if_pending
          elsif @order.unload_stock or @order.unload_stock.nil?
            sod.product.update_stock(sod.quantity*-1) unless sod.product.nil?
            sod.product.update_store_stock(sod.quantity*-1,@order.store_id,self.class,this_method_name) unless sod.product.nil?      
            sod.product.unload_if_pending    
          end

        end  #productos vacios

        session[:order_id] = nil         
        flash[:message] = "<em>Venta registrada exitosamente."

        redirect_to order_report_path(@order.id)
      end
    else
      flash[:error]="<em>Error en la orden</em>"
      render :action=>:index
    end

      end #transaccione
  end

  def destroy
    
    Order.transaction do 
    @order = Order.find(params[:id])
    @order.order_details.each do |order_detail|

      if @order.unload_stock or @order.unload_stock.nil?
        order_detail.product.update_stock(order_detail.quantity)
        order_detail.product.update_store_stock(order_detail.quantity,@order.store_id,self.class,this_method_name)
        order_detail.product.unload_if_pending
      end

      order_detail.destroy

    end
    
    
     @order.destroy

   end
      respond_to do |format|
        format.html { redirect_to orders_catalogue_path }
        format.xml  { head :ok }
      end
    end


  def destroyDetail
    
    OrderDetail.transaction do 
      
    @order_detail = OrderDetail.find(params[:id])
    @order = Order.find(current_order)
    @order.price -= @order_detail.subtotal
    @order.save
    @order_detail.destroy

  end

    respond_to do |format|
      format.js  { 
        render :update do |page|
          @order_details = @order.order_details           
          page.replace 'detalle', :partial => 'product_list'
          page.visual_effect :highlight, 'product_table'            
          page.visual_effect :fade, 'product_error'
          page.call('clean_forms')
          page.replace_html 'product_error', ""
          page.call('setup_'+@order.type)           

        end

      }
    end

  end

  def last_order_number
    @order = Order.find(current_order)
    @order.type = params[:order][:type]
    @order.save
    number = Order.last_number_of(@order.type,get_current_store)
    respond_to do |format|
      format.js  { 
        render :text => number
      }
    end    
  end
  
    def recover
      @order = Order.find(params[:id])
      if @order.status == "accepted" and (@order.unload_stock or @order.unload_stock == nil)
          Order.transaction do
          @order.order_details.each do |order_detail|

            if @order.unload_stock or @order.unload_stock.nil?
              order_detail.product.update_stock(order_detail.quantity)
              order_detail.product.update_store_stock(order_detail.quantity,@order.store_id,self.class,this_method_name)
              order_detail.product.unload_if_pending
            end
          end  #each od
          
          
        end #transaction
        
      end  #unload_stock
      
      @order.status = "open"
      @order.save
      session[:order_id] = params[:id]
      redirect_to orders_path
    end
    
    def reopen
      recover
    end

end
