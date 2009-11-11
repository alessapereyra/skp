class ReportsController < ApplicationController

  protect_from_forgery :except=>[:orders]

  def index

    if admin? or store_supervisor?

      if get_current_store == 4 


        @input_orders = InputOrder.find(:all, :conditions=>"status LIKE 'terminada'",:order=>"created_at DESC", :limit=>5, :include => [:store, :provider])
        @send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'accepted'", :include => [:owner,:store])
        @active_send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'pending'")
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'complete'", :include => [:store,:client])
      else

        @input_orders = InputOrder.find(:all, :conditions=>"status LIKE 'terminada' and store_id = #{get_current_store}",:order=>"created_at DESC", :limit=>5, :include => [:store, :provider])
        @send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'accepted' and (store_id = #{get_current_store} or owner_id = #{get_current_store})", :include => [:owner,:store])
        @active_send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'pending' and owner_id = #{get_current_store}", :include => [:owner,:store])
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'accepted' and (store_id = #{get_current_store} or store_id=#{get_current_store})", :include => [:store,:client])
      end 

    else

      @input_orders = InputOrder.find(:all, :conditions=>"store_id = #{get_current_store} AND status LIKE 'terminada'",:order=>"created_at DESC", :limit=>5, :include => [:store, :provider])
      @send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"store_id = #{get_current_store} AND status LIKE 'accepted'", :include => [:owner,:store])
      @active_send_orders = SendOrder.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"store_id = #{get_current_store} AND status LIKE 'pending'", :include => [:owner,:store])
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC", :limit=>5, :conditions=>"status LIKE 'accepted' and store_id = #{get_current_store}", :include => [:store,:client])

    end


  end

  def product_prices
    @product = Product.find(params[:id])
    @total = @product.prices.length
    @prices = @product.prices.paginate :page=>params[:page], :per_page => 10
  end


  def input_setup
    
        session[:input_time_from] ||= Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
        session[:input_time_to] ||= Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)

        unless params[:from].nil? && params[:to].nil?
          session[:input_time_from] = Date.new(params[:from][:year].to_i,
          params[:from][:month].to_i,
          params[:from][:day].to_i)

          session[:input_time_to] = Date.new(params[:to][:year].to_i,
          params[:to][:month].to_i,
          params[:to][:day].to_i)
        end
     
        @time_from,@time_to = session[:input_time_from], session[:input_time_to]
      
    
  end

  def input_orders
    
    input_setup

    @input_type = "Inventarios"
    @input_type_symbol = :input_orders
    
    if admin? or store_supervisor?

      if get_current_store == 4

        @input_orders = InputOrder.find(:all,:order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and (input_type is NULL or input_type like 'inventario')",:include => [:store, :provider]) 
      else
        @input_orders = InputOrder.find(:all,:order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id=#{get_current_store} and (input_type is NULL or input_type like 'inventario')",:include => [:store, :provider] )

      end

    else
      @input_orders = InputOrder.find(:all,:conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id = #{get_current_store} and (input_type is NULL or input_type like 'inventario')",:order=>"created_at DESC",:include => [:store, :provider])
    end
  end


  def buyings

    input_setup
    
    @input_type = "Compras"
    @input_type_symbol = :buyings

    if admin? or store_supervisor?

      if get_current_store == 4

        @input_orders = InputOrder.find(:all,:order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and input_type like 'compras' ",:include => [:store, :provider]) 
      else
        @input_orders = InputOrder.find(:all,:order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id=#{get_current_store} and input_type like 'compras'",:include => [:store, :provider])

      end

    else
      @input_orders = InputOrder.find(:all,:conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id = #{get_current_store} and input_type like 'compras'", :order=>"created_at DESC",:include => [:store, :provider])
    end
    
    @provider_id = params[:provider_id].to_i
    @category_id = params[:category_id].to_i
    
         if ((not @provider_id.zero?) && (not @category_id.zero?))
            @input_orders = @input_orders.select{|io| io.of_provider?(@provider_id) && io.of_category?(@category_id)  }
          elsif not @provider_id.zero?
            @input_orders = @input_orders.select{|io| io.of_provider?(@provider_id) }            
          elsif not @category_id.zero?
            @input_orders = @input_orders.select{|io| io.of_category?(@category_id) }            
          end
          
    

    render :action => "input_orders"
    
  end
  
  def returns
    
    input_setup
        
    @input_type = "Devoluciones"    
    @input_type_symbol = :returns    

    if admin? or store_supervisor?

      if get_current_store == 4

        @input_orders = InputOrder.find(:all,:order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and input_type like 'devoluciones'" ,:include => [:store, :provider])
      else
        @input_orders = InputOrder.find(:all, :order=>"created_at DESC", :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id=#{get_current_store} and input_type like 'devoluciones'" ,:include => [:store, :provider])

      end

    else
      @input_orders = InputOrder.find(:all, :conditions=>"order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and status LIKE 'terminada' and store_id = #{get_current_store} and input_type like 'devoluciones'",:order=>"created_at DESC",:include => [:store, :provider])
    end

    render :action => "input_orders"
    
  end


  def input_order
    @input_order = InputOrder.find(params[:id])
  end

  def send_orders
    if admin? or store_supervisor?
      if get_current_store == 4 
        @send_orders = SendOrder.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'pending')",:include => [:owner, :store])
      else
        @send_orders = SendOrder.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted'  or status LIKE 'pending') and (store_id = #{get_current_store} or owner_id = #{get_current_store})",:include => [:owner, :store])
      end
    else
      @send_orders = SendOrder.find(:all, :order=>"created_at DESC",:conditions=>"(owner_id = #{get_current_store} or store_id=#{get_current_store}) and (status LIKE 'accepted', or status LIKE 'pending')",:include => [:owner, :store])
    end
  end

  def quote_request
    @quote_request = Quote.find(params[:id])

    @products = []
    @quote_request.products.each do |p|
      @products << p  unless @products.include? p 
    end

  end

  def quote
    @quote = Quote.find(params[:id])
  end

  def quote_requests

    if admin? or store_supervisor?
      if get_current_store == 4 
        @quote_requests = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'requested'",:include => [:client], :page => params[:page])
      else
        @quote_requests = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'requested'",:include => [:client], :page => params[:page])
      end
    else
      @quote_requests = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'requested'",:include => [:client], :page => params[:page])
    end

  end

  def quotes
    if admin? or store_supervisor?
      if get_current_store == 4 
        @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status like 'accepted' or status like 'requested') and (from_web is false or from_web is null)",:include => [:client], :page => params[:page])
      else
        @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status like 'accepted' or status like 'requested') and (from_web is false or from_web is null)",:include => [:client], :page => params[:page])
      end
    else
      @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status like 'accepted' or status like 'requested') and (from_web is false or from_web is null)",:include => [:client], :page => params[:page])
    end
  end

  def web_quotes
    if admin? or store_supervisor?
      if get_current_store == 4 
        @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status like 'requested') and from_web is true",:include => [:client], :page => params[:page])
      else
        @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status like 'requested') and from_web is true",:include => [:client], :page => params[:page])
      end
    else
      @quotes = Quote.paginate(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status like 'requested') and from_web is true",:include => [:client], :page => params[:page])
    end
  end



  def destroyQuote

    Quote.transaction do

      @quote =   Quote.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
      #como la orden AÚN no se ha terminado, el stock no se toca

      @quote.quote_details.each do |sod|


        sod.destroy                             #eliminamos el detalle orden

      end


      @quote.destroy                          #finalmente eliminamos la orden

      redirect_to quotes_report_path


    end

  end

  def sending_guides
    @report_type = ""
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and (sending_type like '' or sending_type IS NULL)",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store} and (sending_type like '' or sending_type IS NULL)",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and (sending_type like '' or sending_type IS NULL)",:include => [:store, :client])
    end
  end

  def perdidas
    @report_type = "perdidas"
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and sending_type like 'perdida'",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store} and sending_type like 'perdida'",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and sending_type like 'perdida'",:include => [:store, :client])
    end
    render :action => "sending_guides"
  end
  
  def devoluciones
    @report_type = "devoluciones"
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and sending_type like 'devolucion'",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store} and sending_type like 'devolucion'",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and sending_type like 'devolucion'",:include => [:store, :client])
    end
    render :action => "sending_guides"
  end  
  
  def mal_estados
    @report_type = "mal_estados"    
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and sending_type like 'mal-estado'",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store}  and sending_type like 'mal-estado'",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and sending_type like 'mal-estado'",:include => [:store, :client])
    end
    render :action => "sending_guides"    
  end


  def consumos_internos
    @report_type = "consumos_internos"        
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and sending_type like 'consumo-interno'",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store} and sending_type like 'consumo-interno'",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and sending_type like 'consumo-interno'",:include => [:store, :client])
    end
    render :action => "sending_guides"    
  end

  def consumos_externos
    @report_type = "consumos_externos"        
    if admin? or store_supervisor?
      if get_current_store == 4 
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and sending_type like 'consumo-externo'",:include => [:store, :client])
      else
        @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"(status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned') and store_id = #{get_current_store} and sending_type like 'consumo-externo'",:include => [:store, :client])
      end
    else
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>"store_id = #{get_current_store} and (status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' ) and sending_type like 'consumo-externo'",:include => [:store, :client])
    end
    render :action => "sending_guides"    
  end


  def send_order
    @send_order = SendOrder.find(params[:id]) unless params[:id].nil?
  end  

  def sending_guide
    @sending_guide = SendingGuide.find(params[:id]) unless params[:id].nil?
  end  


  def order
    @order = Order.find(params[:id],:order=>"created_at DESC",:conditions=>"status LIKE 'accepted'")
  end

  def exit_order
    @exit_order = ExitOrder.find(params[:id],:order=>"created_at DESC")
  end

  def exit_orders
    if params[:from].nil? && params[:to].nil?
      @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
      @both = false

    else

      @time_from = Date.new(params[:from][:year].to_i,
      params[:from][:month].to_i,
      params[:from][:day].to_i)

      @time_to = Date.new(params[:to][:year].to_i,
      params[:to][:month].to_i,
      params[:to][:day].to_i)



    end  

    if params[:exit_order].nil?
      @client_id = 0
    else
      if params[:exit_order][:client_id].blank?
        @client_id = 0
      else
        @client_id = params[:exit_order][:client_id].to_i
      end
    end


    @total = @costs = 0



    if admin? or store_supervisor?
      if get_current_store == 4 
        if @client_id.zero?
          @exit_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'accepted'  and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}'")
        else
          @exit_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'accepted'  and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}' and client_id in (#{@client_id})")          
        end
      else

        if @client_id.zero?
          @exit_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'accepted' and store_id = #{get_current_store}  and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}'")
        else
          @exit_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'accepted' and store_id = #{get_current_store}  and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}' and client_id in (#{@client_id})")
        end

      end

      @exit_orders.each do |o| @costs += o.cost unless o.cost.nil? end  #calculamos 


      else

        if @client_id.zero?
          @exit_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"status LIKE 'accepted' and store_id = #{get_current_store}  and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}'")
        else
          @send_orders = ExitOrder.find(:all, :order=>"created_at DESC",:conditions=>"(store_id=#{get_current_store}) and status LIKE 'accepted' and sending_date >= '#{@time_from}' and sending_date < '#{@time_to+1.day}' and client_id in (#{@client_id})")
        end

      end

      @exit_orders.each do |order| @total += order.price unless order.price.nil? end  #calculamos el total


      end
			
      def inventary

        #Parámetros = FECHA
        #Tienda 
          session[:inventory_time_to] ||= Time.zone.now.to_date

        unless params[:to].nil?

          date_hash = params[:to]
          year,month,day = date_hash[:year],date_hash[:month],date_hash[:day]
          to_date = [year,month,day].map do |t| t.to_i end
          
          session[:inventory_time_to] = Date.new(to_date[0],to_date[1],to_date[2])
        end
        
        
        @time_to = session[:inventory_time_to]

        #Fecha Creación del mundo 
        day_start = Date.new(2008,01,01)

        @time_from = day_start
        
        # valor default de los productos es 0
        # de esa manera, cada vez que agrego un valor, lo incrementa según los ingresos que ha tenido
        total_products = Hash.new
        total_products.default = 0

				#falta and input_orders.order_date < ? " + store_query,'terminada',@time_from,@time_to+1.day])

				unless get_current_store == 4
					
					# Ingresos 
				 iod = InputOrderDetail.accepted.of_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
				 # Ventas
	       od = OrderDetail.accepted.of_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
					# Retornos
					rod = OrderDetail.accepted.returned.of_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
          # Salidas      
          eod = ExitOrderDetail.accepted.of_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
          sod = SendOrderDetail.accepted.from_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
          rsod = SendOrderDetail.accepted.for_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
          sgd = SendingGuideDetail.accepted.of_store(get_current_store).with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
      
      	else
					
				 iod = InputOrderDetail.accepted.with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
				 od = OrderDetail.accepted.with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
         rod = OrderDetail.accepted.returned.with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
				 eod = ExitOrderDetail.accepted.with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
				 sod = []
				 rsod = []
				 sgd = SendingGuideDetail.accepted.with_fields("product_id,quantity").period(:to=>@time_to, :from=>@time_from)
				end

        # el += incrementa el valor anterior o lo inicializa si no existía
        # gracias al valor default que usé al crear el Hash

        iod.each {|id| total_products[to_hash_id(id.product_id)] += id.quantity }

        od.each {|id| total_products[to_hash_id(id.product_id)] -= id.quantity  }
        
        rod.each {|id| total_products[to_hash_id(id.product_id)] += id.quantity }

        eod.each {|id| total_products[to_hash_id(id.product_id)] -= id.quantity }

        sod.each {|id| total_products[to_hash_id(id.product_id)] -= id.quantity  }
        
        rsod.each {|id| total_products[to_hash_id(id.product_id)] += id.quantity }
  
        sgd.each {|id| total_products[to_hash_id(id.product_id)] -= id.quantity  }
        
        
        iod = od = rod = eod = sod = rsod = sgd = nil
        #agrega todos los productos 

				total_products = total_products.reject{|k,v| v.zero? }
        ids = total_products.keys.map { |k| k.to_s[1..-1].to_i }

        session[:inventary_category_id] = params[:category_id] unless params[:category_id].blank?
        session[:inventary_provider_id] = params[:provider_id] unless params[:provider_id].blank?

        @category = session[:inventary_category_id].to_i
        @provider = session[:inventary_provider_id].to_i


        if @category.zero? && @provider.zero?


          RAILS_DEFAULT_LOGGER.error("\n Ninguno  \n")
          
          @products = Product.with_fields("products.id, products.name, products.stock, #{Product.store_stock_field(get_current_store)}, products.category_id, products.created_at").with_store_stock(get_current_store).paginate_by_id(ids,:page => params[:page], :per_page => 50)
          @total_results = Product.with_fields("distinct  products.id,#{Product.store_stock_field(get_current_store)}").with_store_stock(get_current_store).find_all_by_id(ids)
          
          
        elsif @category.zero?
                    
                 RAILS_DEFAULT_LOGGER.error("\n Proveedor  #{@provider} \n")

                  @products = Product.with_fields("products.id, products.name, products.stock, #{Product.store_stock_field(get_current_store)}, products.category_id, products.created_at").from_provider(@provider).with_store_stock(get_current_store).paginate_by_id(ids,:page => params[:page], :per_page => 50)
                  @total_results = Product.with_fields("distinct products.id,#{Product.store_stock_field(get_current_store)}").from_provider(@provider).with_store_stock(get_current_store).find_all_by_id(ids)
          
        elsif @provider.zero?
   
          RAILS_DEFAULT_LOGGER.error("\n Categoria: #{@category}  \n")
          
          @products = Product.with_fields("products.id, products.name, products.stock, #{Product.store_stock_field(get_current_store)}, products.category_id, products.created_at").from_category(@category).with_store_stock(get_current_store).paginate_by_id(ids,:page => params[:page], :per_page => 50)
      @total_results = Product.with_fields("distinct products.id,#{Product.store_stock_field(get_current_store)}").from_category(@category).with_store_stock(get_current_store).find_all_by_id(ids)
        else 
          
          RAILS_DEFAULT_LOGGER.error("\n Ambos valores #{@category} - #{@provider}  \n")
          
          @products = Product.with_fields("products.id, products.name, products.stock, #{Product.store_stock_field(get_current_store)}, products.category_id, products.created_at").from_provider(@provider).from_category(@category).with_store_stock(get_current_store).paginate_by_id(ids,:page => params[:page], :per_page => 50)
                @total_results = Product.with_fields("distinct products.id,#{Product.store_stock_field(get_current_store)}").from_provider(@provider).from_category(@category).with_store_stock(get_current_store).find_all_by_id(ids)
        end
  
        @products.each do |p|
            p.store_stock= [get_current_store,total_products[to_hash_id(p.id)]]
        end
        
        @total_results.each do |p|
            p.store_stock= [get_current_store,total_products[to_hash_id(p.id)]]
        end
 
        total_products = []

        @total = @total_results.size
        @total_cost = @total_results.inject(0){|sum,p| sum + p.cost_price*p.store_stock(get_current_store) }        
        @total_results = []
        @page_results = @products


      end

      def update_products_stock(product,quantity)

        return if quantity.nil?
        store = get_current_store

        if store == 1
          product.stock_trigal.nil? ?  product.stock_trigal = quantity : product.stock_trigal += quantity 
        elsif store == 2
          product.stock_polo.nil? ? product.stock_polo = quantity : product.stock_polo += quantity 
        elsif store == 3
          product.stock_almacen.nil? ? product.stock_almacen = quantity : product.stock_almacen += quantity 
        elsif store == 5  # el ID 4 es de todas las tiendas
          product.stock_clarisa.nil? ? product.stock_clarisa = quantity : product.stock_clarisa += quantity 
        end


      end

    def orders
      if params[:from].nil? && params[:to].nil?
        @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
        @both = false

      else

        @time_from = Date.new(params[:from][:year].to_i,
        params[:from][:month].to_i,
        params[:from][:day].to_i)

        @time_to = Date.new(params[:to][:year].to_i,
        params[:to][:month].to_i,
        params[:to][:day].to_i)



      end
            
      @costs = 0
      @facturas_costs = @boletas_costs = 0     

      if admin? or store_supervisor?

            if get_current_store == 4
              @facturas = Order.find(:all, :order=>"number DESC", :conditions=>"type like 'factura' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    
              @boletas = Order.find(:all, :order=>"number DESC", :conditions=>"type like 'boleta' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    

            else
              @boletas = Order.find(:all, :order=>"number DESC", :conditions=>"store_id = #{get_current_store} and type like 'boleta' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    
              @facturas = Order.find(:all, :order=>"number DESC", :conditions=>"store_id = #{get_current_store} and type like 'factura' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    
            end
            
      else

            @boletas = Order.find(:all, :order=>"number DESC", :conditions=>"type like 'boletas' and status LIKE 'accepted' and store_id = #{get_current_store} and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    
            @facturas = Order.find(:all, :order=>"number DESC",:conditions=>"type like 'facturas' and status LIKE 'accepted' and store_id = #{get_current_store} and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ",:include => [:store])    


      end
        
          @provider_id = params[:provider_id].to_i
          @category_id = params[:category_id].to_i
        
          if ((not @provider_id.zero?) && (not @category_id.zero?))
            
            
              @boletas = @boletas.select{|b| b.of_provider?(@provider_id) && b.of_category?(@category_id) }
              @facturas = @facturas.select{|b| b.of_provider?(@provider_id) && b.of_category?(@category_id) }      
          elsif not @provider_id.zero?
            @boletas = @boletas.select{|b| b.of_provider?(@provider_id) }
            @facturas = @facturas.select{|b| b.of_provider?(@provider_id) }      
            
          elsif not @category_id.zero?
            @boletas = @boletas.select{|b| b.of_category?(@category_id) }
            @facturas = @facturas.select{|b| b.of_category?(@category_id) }                          
          end

          @totals = 0
          @facturas_totals = @boletas_totals = 0
          @boletas.each do |order| @boletas_totals += order.price unless order.price.nil?; @boletas_costs += order.cost unless order.cost.nil?   end  #calculamos el total
          @facturas.each do |order| @facturas_totals += order.price unless order.price.nil?; @facturas_costs += order.cost unless order.cost.nil? end  #calculamos el total
            

    end

            def print_quote
              @quote = Quote.find(params[:id])
              @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
                is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
                @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
                ASC, age_to ASC, sex DESC")


                render :layout=>"print_pages"
              end


              def acceptance
                @order = Order.find(params[:id])
              end

              def acceptances
                @orders = Order.find(:all, :order=>"created_at DESC")    
              end

              def min_stock

                query = ""
                @min_stock = 12

                store_id = get_current_store

                query << "input_orders.store_id = #{store_id} and " unless store_id == 4

                query << case store_id 
                when 1: 
                  "stock_trigal "
                when 2:
                  "stock_polo "
                when 3:
                  "stock_almacen "
                when 4:
                  "stock "
                when 5:
                  "stock_clarisa "
                end

                query << " <= #{@min_stock} and category_id = 11"

                @products = Product.paginate(:all, :group=>"products.id", :joins=>[{:input_order_details=>:input_order}],:conditions=>query,:page=>params[:page], :per_page => 10)


                #  @products = Product.paginate(:all, :conditions=>query,)

              end


              def items_per_day

                if params[:from].nil? && params[:to].nil?
                  @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
                else

                  @time_from = Date.new(params[:from][:year].to_i,
                  params[:from][:month].to_i,
                  params[:from][:day].to_i)

                  @time_to = Date.new(params[:to][:year].to_i,
                  params[:to][:month].to_i,
                  params[:to][:day].to_i)
                end



                if admin? or store_supervisor?

                  if get_current_store == 4
                    @orders = Order.find(:all, :order=>"number DESC", :include=>[:products],:conditions=>"type like 'boleta' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
                  else
                    @orders = Order.find(:all, :order=>"number DESC", :include=>[:products],:conditions=>"store_id = #{get_current_store} and type like 'boleta' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
                  end

                else

                  @orders = Order.find(:all, :order=>"number DESC", :include=>[:products],:conditions=>"store_id = #{get_current_store} and type like 'boleta' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
                end
                @quantities = []
                @amounts = []
                @products = []
                @orders.each do |q| 
                  q.products.each do |p| 
                    unless @products.include? p 
                      @products << p 
                      sum = 0
                      amount = 0
                      q.order_details.find_all_by_product_id(p.id).each do |qd|
                        sum += qd.quantity
                        amount += qd.subtotal
                      end
                      @quantities << sum
                      @amounts << amount
                    end 
                  end
                end

                @total_amount = 0
                @total_quantity = 0
                @amounts.map{|i| @total_amount += i}
                @quantities.map{|i| @total_quantity += i}         

              end

							private
							
              def to_hash_id(id)
                "p#{id}".to_sym
              end

								def get_id(hash)
									hash.keys.first.to_s[1..-1].to_i
								end

            end