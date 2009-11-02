class CatalogueController < ApplicationController

  before_filter :no_cache, :only => :index



  def index
    session[:catalogue_search] = "" if session[:catalogue_search].blank?
    if session[:catalogue_search]
      #CHANGE THIS
      @catalogue = Product.search('"*' + session[:catalogue_search]+'*"', :page=>params[:page], :per_page=>15, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
      
      #@catalogue = Product.find_all_by_code("*" + session[:catalogue_search]+"*", :include=>[:prices],:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)              
    elsif params[:value]
      #CHANGE THIS
      @catalogue = Product.search('"*' + params[:value]+'*"', :page=>params[:page], :per_page=>15, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        

      #@catalogue = Product.find_all_by_code("*" + params[:value]+"*", :include=>[:prices],:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)              
    
    else
        
        @catalogue = Product.search(:page=>params[:page], :per_page=>15, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
        #@catalogue = Product.find :all, :conditions=>"status NOT LIKE 'pendiente'",:order=>"code DESC",:limit => 5
    end
    
    
      
  end
  
  
  def latest_clients
    
    @clients = Client.paginate(:all,:conditions=>"contact_email is not null", :page => params[:page])
    
  end
  
  def send_client_mails
    latest_clients
  end
  
  def send_mails

    latest_clients

    if params[:client]
      params[:client].each do |client,data|
        if data[:sendable]
          begin
            send_client = Client.find(client)
            Emailer::deliver_client_email(send_client)
            flash[:notice] = "<em>Mensajes enviados exitosamente</em>"    
          rescue Exception => ex
            flash[:error] = "<em>Error en algunos datos de env&iacute;o<br />#{ex} <br />#{ex.backtrace}</em> "    
            RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")           
          end
        end #se ha marcado para enviar

      end #cada uno 
            
    end #hay info
    render :action => :send_client_mails

  end
  
  def providers 
    @providers = Provider.find(:all)
  end
  
  def clients 
    @clients = Client.search(:page=>params[:page], :per_page=>15)
  end
  
  def historial
    
    @product = Product.find(params[:id])
    store = Store.find(get_current_store, :include=>[:input_orders,:orders,:send_orders,:sending_guides,:quotes])
    stock = 0

    @input_stock = 0
    @send_stock = 0
    @sold_stock = 0

    @input_order_details = [] #InputOrderDetails
    @order_details = [] #OrderDetails
    @unloaded_order_details = []
    @unloaded_sending_guide_details = []
    @accepted_send_order_details = [] #Accepted SendOrderDetails
    @pending_send_order_details = [] #Pending SendOrderDetails
    @send_order_details = []
    @sending_guide_details = []
    @returned_sending_guide_details = []
    @requested_quote_details = []
    @exit_order_details = []
      
      #Obtenemos los ingresos, ventas, traslados de la tienda
      store.input_orders.accepted.each {|io|  temp = io.input_order_details.find_all_by_product_id(@product.id); temp.each do |t|  @input_order_details << t unless t.nil? end  }

      store.orders.accepted.each {|io|  temp = io.order_details.find_all_by_product_id(@product.id); temp.each do |t| 
                @order_details << t unless t.nil? end  }

      store.orders.unloaded.each {|io|  temp = io.order_details.find_all_by_product_id(@product.id); temp.each do |t| 
                          @unloaded_order_details << t unless t.nil? end  }


     store.send_orders.accepted.each {|io|  temp = io.send_order_details.find_all_by_product_id(@product.id); temp.each do |t| @accepted_send_order_details << t unless t.nil? end   }
      store.owned_send_orders.pending.each {|io| temp = io.send_order_details.find_all_by_product_id(@product.id); temp.each do |t| @send_order_details << t unless t.nil? end }

      store.owned_send_orders.accepted.each {|io| temp = io.send_order_details.find_all_by_product_id(@product.id); temp.each do |t| @send_order_details << t unless t.nil? end }
        
      store.sending_guides.accepted.each {|io| temp = io.sending_guide_details.find_all_by_product_id(@product.id); temp.each do |t| @sending_guide_details << t unless t.nil? end }

      store.sending_guides.unloaded.each {|io| temp = io.sending_guide_details.find_all_by_product_id(@product.id); temp.each do |t| @unloaded_sending_guide_details << t unless t.nil? end }

        
      store.sending_guides.returned.each {|io| temp = io.sending_guide_details.find_all_by_product_id(@product.id); temp.each do |t| @returned_sending_guide_details << t unless t.nil? end }

      store.exit_orders.accepted.each {|io| temp = io.exit_order_details.find_all_by_product_id(@product.id); temp.each do |t| @exit_order_details << t unless t.nil? end }

    #  @product.quotes.requested.each {|q| temp = q.quote_details.find_all_by_product_id(@product.id); temp.each do |t| @requested_quote_details << t unless t.nil? and not t.stock_from_store(get_current_store).zero? end  }
      store.quotes.requested.each {|q| temp = q.quote_details.find_all_by_product_id(@product.id,:conditions=>"additional is false or additional is null"); temp.each do |t| @requested_quote_details << t unless t.nil? and not t.stock_from_store(get_current_store).zero? end }  
      @input_order_details.map {|i|  stock += i.quantity; @input_stock += i.quantity }
      @exit_order_details.map {|i|  stock -= i.quantity; @sold_stock += i.quantity }
      @order_details.map {|i|  stock -= i.quantity; @sold_stock += i.quantity }
      @send_order_details.map {|i| stock -= i.quantity; @send_stock += i.quantity }
      @accepted_send_order_details.map {|i| stock += i.quantity; @input_stock += i.quantity }
      @sending_guide_details.map {|i| stock -= i.quantity; @send_stock += i.quantity }
      @returned_sending_guide_details.map {|i| @input_stock += i.quantity;@send_stock += i.quantity }      
      @requested_quote_details.map{ |i| stock -= i.stock_from_store(get_current_store); @send_stock += i.stock_from_store(get_current_store)}
      @stock = stock
    
  end
  
  def search_product
       search = ""

       if params[:product]
          search = params[:product][:name] 
        else
          search = params["q"] unless params["q"].nil?
        end

       session[:product_search] = search unless search == ""
       RAILS_DEFAULT_LOGGER.error("\n #{ session[:product_search]}  \n")  
       @catalogue = [] 
       @catalogue = Product.search('"*' + session[:product_search] + '*"', :page => params[:page], :per_page => 15, :conditions=>{'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        


      respond_to do |wants|        
        wants.html {
          
          render :action => "index"
        }
        wants.js { 
          
          render :update do |page|
            #CHANGE THIS
 #acts_as_ferret :fields=>[:name, :description, :code, :category_name, :subcategory_name,:brand_name,:product_provider_codes]
 
        #    search = Product.new_search
         #   search.conditions.or_name_contains = params["q"]
        #    search.conditions.or_description_contains = params["q"]
        #    search.conditions.or_code_contains = params["q"]            
        #    search.conditions.or_category_name_contains = params["q"]            
          #  search.conditions.or_subcategory_name_contains = params["q"]                        
          #  search.conditions.or_brand_name_contains = params["q"]            
          #  search.conditions.or_product_provider_codes_contains = params["q"]                                               
#        #    search.limit 
        #    @catalogue = search.all            
            
         #   @catalogue = Product.find_all_by_code(params["q"],:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
            page.replace 'detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'list'                
          end
          
          }
        
      end
      
  end

  def search_client

      respond_to do |wants|        
        wants.js { 
          
          render :update do |page|
            @clients = Client.search  '*' + params["q"] + '*', :page=>params[:page], :per_page=>15 
            page.replace 'detalle', :partial => 'client_list'
            page.visual_effect :highlight, 'list'                
          end
          
          }
        
      end
      
  end

  def search_client_for_sending
		
			search = if params[:client]
				params[:client][:name].blank? ? " " : params[:client][:name] 
			elsif params["q"]  
				params["q"]
			else
				" "
			end

      if search.blank?
        latest_clients
      else  
        @clients = Client.search  '*' + search + '*', :page=>params[:page], :per_page=>15 
      end

      respond_to do |wants|        
        wants.js { 
          
          render :update do |page|
            page.replace 'detalle', :partial => 'send_client_list'
            page.replace 'paginate_clients', :partial => 'paginate_clients'
						page.show 'detalle'             
          end
          
          }
        
      end
      
  end  

  
end