class InventoryController < ApplicationController
  
  
  before_filter [:has_privileges?,:no_cache]
    
        uses_tiny_mce
    
  def index 
    
      @product = Product.new
      @product.category_id = session[:category_id] unless session[:category_id].nil?
      @product.subcategory_id = session[:subcategory_id] unless session[:subcategory_id].nil?  
      @product.brand_id = session[:brand_id] unless session[:brand_id].nil?  
      @product.code = Product.last_code.next
      @price = Price.new
      @input_order_detail = InputOrderDetail.new
    
  end
  
  def save_prices
    
    #Create four Prices
    Price.transaction do 
      base_price = Price.new
      base_price.product_id = @iod.product_id
      base_price.input_order_detail_id = @iod.id
      base_price.amount = (params[:price][:amount]).to_f || 0.00
      base_price.description = "Precio base"
      base_price.discount = 0
      base_price.save!       
    end

    Price.transaction do
      boxed_price = Price.new
      boxed_price.product_id = @iod.product_id
      boxed_price.input_order_detail_id = @iod.id
      boxed_price.amount = (params[:input_order][:boxed_price]).to_f || 0.00
      boxed_price.description = "Precio en caja"
      boxed_price.discount = 0
      boxed_price.save!

    end

    Price.transaction do
      wholesale_price = Price.new      
      wholesale_price.product_id = @iod.product_id
      wholesale_price.input_order_detail_id = @iod.id
      wholesale_price.amount = (params[:input_order][:wholesale_price]).to_f || 0.00
      wholesale_price.description = "Precio mayorista"
      wholesale_price.discount = 0
      wholesale_price.save!      
      p = @iod.product
      p.corporative_price = params[:input_order][:wholesale_price]
      p.save      
    end

    Price.transaction do
      final_price = Price.new
      final_price.product_id = @iod.product_id
      final_price.input_order_detail_id = @iod.id
      final_price.amount = (params[:input_order][:final_price]).to_f || 0.00
      final_price.description = "Precio Tienda 1"
      final_price.discount = 0
      final_price.save!
    end

    Price.transaction do
      final_price_polo = Price.new
      final_price_polo.product_id = @iod.product_id
      final_price_polo.input_order_detail_id = @iod.id
      final_price_polo.amount = (params[:input_order][:final_price_polo]).to_f || 0.00
      final_price_polo.description = "Precio Tienda 2"      
      final_price_polo.discount = 0
      final_price_polo.save!
    end
    
  end
  
  def add_to_current_input_order
    
    @iod = InputOrderDetail.new
    @iod.input_order_id = current_input_order
    @iod.product_id = @product.id
    @iod.cost = params[:input_order_detail][:cost]
    @iod.additional_code = params[:input_order_detail][:additional_code]
    @iod.quantity = params[:input_order_detail][:quantity]
    if @iod.valid?
      @input_order = @iod.input_order
      @input_order.cost += @iod.quantity*@iod.cost.to_f
    
      @input_order.save
    
      @iod.save!
    
      save_prices if admin?
      
      return true  
    
    else
      
      return false
    
    end
    
    
    
  end
  
  def barcode 
    
    @product = Product.find(params[:id])
    if @product
        @product.create_barcode!
        redirect_to print_tag_path(@product.id)
    else
        flash[:error] = "Error en la creación"
        redirect_to print_tag_path(@product.id)
    end
    
  end
  
  def create
    
      @product = Product.new(params[:product])
      session[:category_id] = params[:product][:category_id]
      session[:subcategory_id] = params[:product][:subcategory_id]  
      session[:brand_id] = params[:product][:brand_id]    
      @product.stock = 0 if @product.stock.nil?
      @product.stock_trigal = 0
      @product.stock_polo = 0
      @product.status = "pendiente"

      if @product.save

        @product.create_barcode!

        if self.add_to_current_input_order
            flash[:notice] = '<em id="message">Producto Ingresado exitosamente</em>'
            
      
            respond_to do |format|
           
              format.html { redirect_to input_orders_path }
              format.xml  { render :xml => @product, :status => :created, :location => @product }
              
            end  # respond_to
            
         else

            respond_to do |format|

              format.html { 
                flash[:notice] = '<em id="message">El producto ya existe o tiene algunos errores</em>'
                #redirect_to inventory_path 
                @product
                render :action => "index"
              }
              
            end  #respond_to

         end #add_to_current
         
        #end  # save
        
      else
        
        respond_to do |format|

          format.html { 
            flash[:notice] = '<em id="message">El producto ya existe o tiene algunos errores</em>'
            @product
            render :action => "index"
            #redirect_to inventory_path 
          }
          
        end  #respond_to

      end
    
  end
  
  def add_other
    
    
     @product = Product.new(params[:product])
      @product.stock = 0 if @product.stock.nil?
      @product.stock_trigal = 0
      @product.stock_polo = 0
      
      respond_to do |format|
         if @product.save

           @product.create_barcode!
           
           self.add_to_current_input_order
          # flash[:notice] = 'Producto ingresado al cat&aacute;logo'
           format.html { redirect_to products_path }
           format.xml  { render :xml => @product, :status => :created, :location => @product }
           format.js {
             
              render :update do |page|
                page.call('clean_forms')            
                page.replace_html 'product_error', ""                                    
                page.visual_effect :show, 'messages', :duration=>"5.0"
                page.replace_html 'messages', "<em id='message'>Producto Ingresado exitosamente</em>"
                page.visual_effect :highlight, 'messages'             
           end
             
             
           }
         else
           format.html { redirect_to products_path }
           format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
           format.js  { 
             
             render :update do |page| 
               page.replace_html 'messages', ""   
               page.visual_effect :show, 'product_error', :duration=>"5.0"
               page.replace_html 'product_error', "<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos: <br />#{@product.errors.map{|error, mensaje| "#{error.humanize.capitalize} #{mensaje} <br />" }}</em>"
               page.visual_effect :highlight, 'new_product_error'             
             
             end
             
              }           
         end
      end
    
    
  end
  
  
  def update
    
    
  end
  
  
  
  def destroy
    
  end
  
  def tags
    @products = Product.paginate(:all, :page=>params[:page], :per_page=>15, :order=>"updated_at DESC")
  end
  
  def client

    render :layout=>false
  end
  
  def print
    
    @product = Product.find(params[:id])
    
  end

  def print_tag
    
    @product = Product.find(params[:id])
    @copies = params[:copies].to_i
    @store = params[:store]
    @store ||= 1
    render :layout=>'print'
  end

  
  def print_tags
    @input_order = InputOrder.find(params[:id])
    render :layout=>'print'    
  end
  
  def print_send_order_tags
    @send_order = SendOrder.find(params[:id])
    render :layout=>'print'    
    
  end
  
  def print_input_order
    
    @input_order = InputOrder.find(params[:id])
    
  end
  
  def print_send_order
    
    @send_order = SendOrder.find(params[:id])
    
  end
  
  def search_product

       respond_to do |wants|   
         wants.html {
           @products = Product.search('"*' + params["q"]+'*"', :page => params[:page], :per_page => 15, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
           render :action=>"tags"
           
         }     
         wants.js { 

           render :update do |page|
             #CHANGE THIS
             @products = Product.search('"*' + params["q"]+'*"', :page => params[:page], :per_page => 15, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        
             page.replace 'detalle', :partial => 'product_list'
             page.visual_effect :highlight, 'list'                
           end

           }

       end

   end
   
end