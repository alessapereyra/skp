class PrintController < ApplicationController
  
  
  def send_order
    @send_order = SendOrder.find(params[:id])
    @report_name = "guia_de_salida_traslado"
    render :layout=>"print_reports"
  end
  
  def sending_guide
    @sending_guide = SendingGuide.find(params[:id])
    @report_name = "guia_de_salida_traslado"
    render :layout=>"print_reports"
  end
  
  def input_order
    @input_order = InputOrder.find(params[:id])
    @report_name = "guia_de_salida_traslado"
    render :layout=>"print_reports"
  end
  
  def inventary
    
      #Parámetros = FECHA
      #Tienda 
      session[:inventory_time_from] ||= Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
      session[:inventory_time_to] ||= Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)

      @time_from,@time_to = session[:inventory_time_from], session[:inventory_time_to]

      unless get_current_store == 4 

        store_query = "and store_id = #{get_current_store}"

      end


      total_products = Hash.new

      # + INGRESOS    
      @inputs = InputOrder.find(:all, :conditions=>["status LIKE 'terminada' and order_date >= ? and order_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:input_order_details,:products])

      @inputs.each do |i| 

             i.products.each do |p|

             if total_products.include? p
               total_products["#{p.id}".to_sym].stock += p.stock
               update_products_stock(total_products["#{p.id}".to_sym],p.stock)
             else
               total_products["#{p.id}".to_sym] = p unless p.nil?
             end 

           end

       end



      # - SALES (Boleta o Factura)
      @sales = Order.find(:all, :conditions=>["(type like 'factura' or type like 'boleta') and status LIKE 'accepted' and order_date >= ? and order_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:order_details,:products] )    

      @sales.each do |s|
        
        s.products.each do |p|
          
          if total_products.include? p

            total_products["#{p.id}".to_sym].stock -= p.stock
            update_products_stock(total_products["#{p.id}".to_sym],-p.stock)
#            else
#              total_products["#{p.id}".to_sym] = p unless p.nil?
           end 
          
        end
        
        
      end


      # RETORNOS
      @returns = Order.find(:all, :conditions=>["type like 'nota_de_credito' and status LIKE 'accepted' and order_date >= ? and order_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:order_details,:products])    

      @returns.each do |r|
        
        r.products.each do |p|

          if total_products.include? p            
          total_products["#{p.id}".to_sym].stock += p.stock
          update_products_stock(total_products["#{p.id}".to_sym],p.stock)
 #         else
#            total_products["#{p.id}".to_sym] = p unless p.nil?
          end 

          
        end
        
      end

      # - EXIT_ORDERS
      @exit_orders = ExitOrder.find(:all, :conditions=>["status LIKE 'accepted' and sending_date >= ? and sending_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:exit_order_details,:products])

      @exit_orders.each do |eo|
        
        eo.products.each do |p|

          if total_products.include? p
          total_products["#{p.id}".to_sym].stock -= p.stock
          update_products_stock(total_products["#{p.id}".to_sym],-p.stock)            
 #         else
  #           total_products["#{p.id}".to_sym] = p unless p.nil?
          end 
          
        end
        
      end

      # - SEND_ORDERS (salvo en todas las tiendas) 
      # + RECEIVED_ORDERS A ESTA TIENDA
      unless get_current_store == 4
        @send_orders = SendOrder.find(:all, :order=>"created_at DESC",:conditions=>["status LIKE 'accepted' and send_date >= ? and send_date < ? and owner_id = #{get_current_store}",@time_from,@time_to+1.day], :include=>[:send_order_details,:products])
        @received_orders = SendOrder.find(:all, :order=>"created_at DESC",:conditions=>["status LIKE 'accepted' and send_date >= ? and send_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:send_order_details,:products])
      else
        @send_orders = []
        @received_orders = []
      end

      @send_orders.each do |so|
        
        so.products.each do |p|

          if total_products.include? p
          total_products["#{p.id}".to_sym].stock -= p.stock
          update_products_stock(total_products["#{p.id}".to_sym],-p.stock)            
   #       else
    #         total_products["#{p.id}".to_sym] = p unless p.nil?
          end 
          
        end
        
      end

      @received_orders.each do |ro|
        
        ro.products.each do |p|
          
          if total_products.include? p
          total_products["#{p.id}".to_sym].stock += p.stock
          update_products_stock(total_products["#{p.id}".to_sym],p.stock)            
          else
             total_products["#{p.id}".to_sym] = p unless p.nil?
          end 
          
        end
        
      end

      # - SENDING_GUIDES
      @sending_guides = SendingGuide.find(:all, :order=>"created_at DESC",:conditions=>["status LIKE 'accepted' or status LIKE 'complete' or status LIKE 'returned' and sending_date >= ? and sending_date < ? " + store_query,@time_from,@time_to+1.day], :include=>[:sending_guide_details,:products])

      @sending_guides.each do |sg|
        
        sg.products.each do |p|
          
          if total_products.include? p
          total_products["#{p.id}".to_sym].stock -= p.stock
          update_products_stock(total_products["#{p.id}".to_sym],-p.stock)            
   #       else
   #          total_products["#{p.id}".to_sym] = p unless p.nil?
          end 
          
        end
        
      end
      
      #agrega todos los productos 

           @category = session[:inventary_category_id].to_i
            @provider = session[:inventary_provider_id].to_i


            if (not @category.zero?) && (not @provider.zero?)
              RAILS_DEFAULT_LOGGER.error("\n Ambos valores #{@category} - #{@provider}  \n")
              @products = total_products.values.select {|p| (not p.store_stock(get_current_store).zero?) && (p.category_id == @category) && (p.providers.include? @provider) }.sort_by { |k| k['created_at'] }.reverse
            elsif not @category.zero?
              RAILS_DEFAULT_LOGGER.error("\n Categoria: #{@category}  \n")
              @products = total_products.values.select {|p| (not p.store_stock(get_current_store).zero?) && (p.category_id == @category);   } # .sort_by { |k| k['created_at'] }.reverse
            elsif not @provider.zero?
              RAILS_DEFAULT_LOGGER.error("\n Proveedor  #{@provider} \n")
              @products = total_products.values.select {|p| (not p.store_stock(get_current_store).zero?) && (p.providers.include? @provider) }.sort_by { |k| k['created_at'] }.reverse
            else 
              RAILS_DEFAULT_LOGGER.error("\n Ninguno  \n")
              @products = total_products.values.select {|p| not p.store_stock(get_current_store).zero?  }.sort_by { |k| k['created_at'] }.reverse
            end
            
             
  # @products = @products.select {|p| not p.store_stock(get_current_store).zero?  }

      @total = @products.size

      @page_results = @products.paginate(:page => params[:page], :per_page => 50)

      @total_cost = @products.inject(0){|sum,p| sum + p.cost_price*p.store_stock(get_current_store) }        

      @report_name = "inventary"
      render :layout=>"print_reports"
    
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
  
  def order
    @order = Order.find(params[:id])
    @report_name = @order.attributes["type"]
    render :layout=>"print_reports"
  end
  
  def exit_order
    @exit_order = ExitOrder.find(params[:id])
    @report_name = "guia_de_salida_traslado"
    render :layout =>"print_reports"
  end
  
end