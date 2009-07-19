class ProductsController < ApplicationController
    
      before_filter :has_privileges?
      
      uses_tiny_mce :options => {
                                    :plugins => %w{ table fullscreen }
                                  }
      
      
    protect_from_forgery :only => [:create, :update, :destroy]
    
    def index 
      @products = Product.paginate(:all, :page=>params[:page], :per_page=>20)
    end


    def search_product
      search = ""

      if params[:product]
         search = params[:product][:name] 
      end

      session[:product_search] = search unless search == ""
      
      #@clients = Client.search  '*' + params["q"] + '*' # :limit => 15 #:conditions=>"status NOT LIKE 'pendiente'", 
      
      @products = Product.search('"*' + session[:product_search]+'*"', :page => params[:page], :per_page => 20, :conditions=>{'status' => 'terminado', 'status'=>'terminada'}) #,#:conditions=>"status NOT LIKE 'pendiente'",:limit => 15)        


        respond_to do |wants|        
          wants.html { 
            render :action => "index"
            }
          wants.js { 

            render :update do |page|
              #CHANGE THIS
              page.replace 'detalle', :partial => 'product_list'
              page.visual_effect :highlight, 'list'                
            end

            }

        end

    end
    
    
    def new
        @product = Product.new
    end

    def create 
      @product = Product.new(params[:product])
      
      respond_to do |format|
         if @product.save
           flash[:notice] = 'Producto ingresado al cat&aacute;logo'
           format.html { redirect_to products_path }
           format.xml  { render :xml => @product, :status => :created, :location => @product }
         else
           format.html { redirect_to products_path }
           format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
         end
      end   
         
    end
    
    def show
          @product = Product.find(params[:id])
          @product.additional_code = @product.input_order_details.last.additional_code
          respond_to do |format|
            format.js {render :text => @product.to_json, :layout=>false}
        end
    end
    
    def edit
      @product = Product.find(params[:id])
      #Traer los IOD que cumplan con el stock.
      @input_order_details = @product.active_input_orders      
    end
    
    def update
    
      @product = Product.find(params[:id])
       respond_to do |format|
          if @product.update_attributes(params[:product])
            flash[:notice] = 'Producto actualizada.'
            format.html { redirect_to products_path }
            format.xml  { head :ok }
          else
            format.html { 
              @input_order_details = @product.active_input_orders                    
              render :action => "edit" 
              
              }
            format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
          end
        end
    end
    
    def recalculate_this_stock
      
      @product = Product.find(params[:id])
      
      
      # Calcular stocks de los que tengan. 
      # Cuando se transforme en guía de salida, devolverá el stock?
      # y cuando se cambie a factura?
      @product.recalculate_stocks      
      flash[:notice] = 'Producto actualizada.'      
      redirect_to products_path
      
    end

    def recalculate_stocks
      
      Product.all.each do |p|

        p.recalculate_stocks

      end      
    
      flash[:notice] = 'Productos actualizada.'      
      redirect_to products_path
      
    end
    
    def destroy
      
        @product = Product.find(params[:id])
        
        if @product.orders.accepted.empty? &&
           @product.send_orders.accepted.empty? &&
           @product.sending_guides.accepted.empty? &&
           @product.input_orders.accepted.empty?
    
           @product.destroy
        
        else
          
          flash[:notice] = "El producto no puede ser eliminado, ya tiene un registro de movimientos"
             
         end
           
          redirect_to products_path
      
    end
    
end
