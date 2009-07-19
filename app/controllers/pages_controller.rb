class PagesController < ApplicationController

  before_filter :load_catalogue, :only=>[:catalogo]

  skip_before_filter :is_authenticated

  protect_from_forgery :only=>[:new], :secret => '852e5b7badfdd5ddf13d56af9385c874'

  #caches_page :vale_navidad, :catalogo, :conocenos, :contactanos, :empresas, :servicios

  def load_catalogue
    #CHANGE THIS
    @catalogue = Product.search(:page => params[:page], :per_page => 20,:conditions=>{"visible"=>'1'}, :with => {:stock => 1..1000},:order=>"updated_at DESC", :without => {"category_id" => "11"})        
    session[:product_search] = ""
    session[:product_add] = ""
    @alternative = []
    session[:price_from] = 0
    session[:price_to] = 1000
    session[:product_from] = 0
    session[:product_to] = 20
    @search = get_search_message    
  end

  def setup_values
  
       begin
         @quote = Quote.find(current_quote)
         session[:product_search] ||= " "
         session[:product_add] ||=" "
         session[:price_from] ||= 0
         session[:price_to] ||= 1000
         session[:product_from] ||= 0
         session[:product_to] ||= 20
        rescue
          @quote = Quote.new
          session[:product_search] ||= " "
          session[:product_add] ||=" "
          session[:price_from] ||= 0
          session[:price_to] ||= 1000
          session[:product_from] ||= 0
          session[:product_to] ||= 20

          @quote.document = "De Web"
          @quote.save
          cookies[:quote_id] = @quote.id.to_s
          cookies[:quote_id].to_i
        end
    
  end
  
  
  def price_conditions
    
    "(status like 'terminada') and visible != false and " + 
    "(" +
    "(" +
    "age_to = #{session[:product_from]} " + 
    "or age_from = #{session[:product_to]} " +
    "or (age_from <= #{session[:product_to]} and age_to >= #{session[:product_from]} ) " +
    "or (age_from <= #{session[:product_from]} and age_to >= #{session[:product_to]} ) " +      
    "or (age_from >= #{session[:product_from]} and age_to <= #{session[:product_to]} ) " +
    ") " +
    "or (age_from IS NULL or age_to IS NULL)" +
    ") " + 
    "and (corporative_price >= #{session[:price_from].to_f*0.9} and corporative_price <= #{session[:price_to].to_f*1.1}) "
    
  end
  

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  def vale_navidad

  end
  
  def print_quote
    @quote = Quote.find(params[:id])
        @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
          is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
          @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
          ASC, age_to ASC, sex DESC")
    render :layout =>"print_pages"
  end

  def cotizaciones
    email = Base64.decode64(params[:contact_name])    
    @quotes = Quote.find_all_by_sending_details(email,:conditions=>"status like 'accepted' or status like 'requested'")
    unless @quotes.empty?
      
      if @quotes.size == 1
        @quote = @quotes.first
      @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
        is null)",@quote.id],:order => "months DESC, age_from ASC, age_to ASC, pack_number ASC, sex DESC ")
        @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "months DESC, age_from 
        ASC, age_to ASC, pack_number ASC, sex DESC")
      else
        render :action=>"lista_cotizaciones"
      end
        
      else
        redirect_to "http://www.skykidsperu.com"
      end
    end


    def lista_cotizaciones
      
    end

    def cotizacion_numerada
       email = Base64.decode64(params[:contact_name])    
        @quotes = Quote.find_all_by_sending_details(email,:conditions=>"status like 'accepted' or status like 'requested'")
        unless @quotes.empty?

          if @quotes.size == 1
            @quote = @quotes.first
          else
            @quote = @quotes[params[:item].to_i-1]
          end

          @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
            is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
            @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
            ASC, age_to ASC, sex DESC")
          


          else
            redirect_to "http://www.skykidsperu.com"
          end
    end

    def catalogo
      begin
        @quote = Quote.find(current_quote)
      rescue
        @quote = Quote.new
        @quote.document = "De Web"
        @quote.save
        cookies[:quote_id] = @quote.id.to_s
        cookies[:quote_id].to_i
      end

    end

    def conocenos

    end

    def contactanos

    end
    
    def promocion_justimeano
      
      
      
    end
    
    def campana_escolar
      
      
    end
    
    def dia_madre
      
    end

    def empresas

    end

    def servicios

    end

    def send_quote

      @quote = Quote.find(current_quote)
      
      if params[:quote_detail]
        params[:quote_detail].each do |qd,params|
          quote_detail = QuoteDetail.find(qd)
          quote_detail.update_attributes(params)
        end
      end

      @quote.from_web = true
      @quote.quote_date = Time.zone.now
      @quote.document = Quote.last_number.to_s
          
      if @quote.childless?  

        flash[:error] = "<span class='error'>Antes de enviar la consulta, agregue productos a &eacute;sta.</span>"
        render :action=>:consulta

      elsif params[:quote][:client].nil? || params[:quote][:email].nil? ||
        params[:quote][:client].empty? || params[:quote][:email].empty? 

        flash[:error] = "<span class='error'>Debe llenar todos los campos antes de enviar la consulta</span>"
        render :action=>:consulta

      else

        @quote.sending_details = params[:quote][:email]
        @quote.quote_comments = "Para: " + params[:quote][:client]
        @quote.save
        cookies[:quote_id] = nil
        flash[:message] = "<span>Consulta enviada exitosamente</span>"
        redirect_to "/web/consulta"

      end

    end

    def current_quote
      begin
        if cookies[:quote_id].nil? or not Quote.exists?(cookies[:quote_id].to_i)
          @quote = Quote.new
          @quote.document = Quote.last_number.to_s
          @quote.save
          cookies[:quote_id] = @quote.id.to_s
        end

        cookies[:quote_id].to_i
      rescue
        @quote = Quote.new
        @quote.document = "De Web"
        @quote.save
        cookies[:quote_id] = @quote.id.to_s
        cookies[:quote_id].to_i    
      end
    end

    def add_to_quote

      @quote_detail = QuoteDetail.new
      @quote_detail.quote_id = current_quote
      @quote_detail.product_id = params[:id].to_i
      @quote_detail.quantity = 1 #params[:quote_detail][:quantity].to_i
      @quote_detail.price = 0
      @quote_detail.save!


      respond_to do |format|
        format.html { render :layout=>'small_page' }
        format.xml  { render :xml => @product }
        format.js {

          render :update do |page|
            @quote = @quote_detail.quote.reload
            page.replace_html 'request_result', "<span>Producto agregado a su consulta. Puede <a href='/web/consulta/'>revisarla</a> o seguir añadiendo productos</span>"
            page.visual_effect :highlight, 'request_result'
            page.replace 'consulta', :partial => 'consulta'
            page.visual_effect :highlight, 'consulta'   
            page << "rebind_facebox();"                        
          end



        }
      end


    end

    # GET /pages/1
    # GET /pages/1.xml
    def agregar_producto
      @product = Product.find(params[:id])
      respond_to do |format|
        format.html { render :layout=>'small_page' }
        format.xml  { render :xml => @product }
      end
    end



    def send_email
      begin
        Emailer::deliver_contact_email(params[:email])
        flash[:message] = "<span>Mensaje enviado satisfactoriamente</span>"
        render :action =>:contactanos
      rescue
        flash[:message] = "<span>Hubieron algunos campos err&oacute;neos. Verifique que ingres&oacute; una cuenta de correo v&aacute;lida.</span>"
        render :action =>:contactanos

      end
    end

    # GET /pages/1
    # GET /pages/1.xml
    def show
      @page = Page.find_by_title(params[:title])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @page }
      end
    end

    # GET /pages/1
    # GET /pages/1.xml
    def detalle
      @product = Product.find(params[:id])

      respond_to do |format|
        format.html { render :layout=>'small_page' }
        format.xml  { render :xml => @product }
      end
    end

    def consulta
      begin
        @quote = Quote.find(current_quote)
      rescue
        @quote = Quote.new
        @quote.document = "De Web"
        @quote.save
        cookies[:quote_id] = @quote.id.to_s
        cookies[:quote_id].to_i
      end
    end


    def popout 
      respond_to do |format|
        format.js {
          render :update do |page|

            page << "statuspopup(#{params[:id]});"

          end
        }    
      end
    end

    # GET /pages/new
    # GET /pages/new.xml
    def new
      @page = Page.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @page }
      end
    end

    # GET /pages/1/edit
    def edit
      @page = Page.find(params[:id])
    end

    # POST /pages
    # POST /pages.xml
    def create
      @page = Page.new(params[:page])

      respond_to do |format|
        if @page.save
          flash[:notice] = 'Page was successfully created.'
          format.html { redirect_to(@page) }
          format.xml  { render :xml => @page, :status => :created, :location => @page }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /pages/1
    # PUT /pages/1.xml
    def update
      @page = Page.find(params[:id])

      respond_to do |format|
        if @page.update_attributes(params[:page])
          flash[:notice] = 'Page was successfully updated.'
          format.html { redirect_to(@page) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /pages/1
    # DELETE /pages/1.xml
    def destroy
      @page = Page.find(params[:id])
      @page.destroy

      respond_to do |format|
        format.html { redirect_to(pages_url) }
        format.xml  { head :ok }
      end
    end

    def query_values
        catalogue_ids = []
        ids = Product.search_for_ids(:conditions=>{"visible"=>'1','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'status'=>'terminada','age_to'=>session[:product_from]}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
        ids2 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'age_from'=>session[:product_to]}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
        ids3 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'age_from'=>0..session[:product_to].to_i,'age_to'=>session[:product_from].to_i..20}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
        ids4 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'age_from'=>0..session[:product_from].to_i,'age_to'=>session[:product_to].to_i..20}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
        ids5 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'age_from'=>session[:product_from].to_i..20,'age_to'=>0..session[:product_to].to_i}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
        ids.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids2.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids3.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids4.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids5.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }                  
        @catalogue = Product.paginate(:all, :page=>params[:page], :per_page=>20,:conditions => ["id IN (#{catalogue_ids.join(', ')})"]) 
    end

    def set_price_from
      setup_values 
      session[:price_from] = params["q"]
      #CHANGE THIS
      query_values
 
 #     @catalogue =  Product.find_all_by_code("*", {:page => params[:page], :per_page => 20},{:conditions=>query_conditions,:order=>"created_at DESC"})  
      @search = get_search_message
      @alternative = []
      respond_to do |wants|    

        wants.html {

          render :action=>:catalogo

        }


        wants.js { 
          render :update do |page|     
            page.replace 'detalle', :partial => 'product_list'
            page.replace_html 'search_terms', @search
            page.visual_effect :highlight, 'list'             
            page << "rebind_facebox();"   
            page << "$.scrollTo('#inside',500);"   
          end

        }

      end

    end

    def set_price_to
      setup_values 
      session[:price_to] = params["q"]

      #CHANGE THIS
     # @catalogue =  Product.find_all_by_code("*", {:page => params[:page], :per_page => 20},{:conditions=>query_conditions,:order=>"created_at DESC"})  
      query_values
      @search = get_search_message
      @alternative = []
      respond_to do |wants|    

        wants.html {

          render :action=>:catalogo

        }


        wants.js { 
          render :update do |page|     
            page.replace 'detalle', :partial => 'product_list'
            page.replace_html 'search_terms', @search
            page.visual_effect :highlight, 'list'             
            page << "rebind_facebox();"   
            page << "$.scrollTo('#inside',500);"               
          end

        }

      end

    end


    def set_price
      setup_values       
      session[:price_from] = params["q"]
      session[:price_to] = params["t"]

      #CHANGE THIS
      query_values
      @alternative = []
      @search = get_search_message
      respond_to do |wants|      
        wants.html {
          render :action=>:catalogo
        }

        wants.js { 
          render :update do |page|    
            page.replace_html 'search_terms', @search
            page.replace 'detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'list'  
            page << "rebind_facebox();"                                 
            page << "$.scrollTo('#inside',500);"               
          end

        }



      end

    end


    def query_conditions

        "(status like 'terminada') and visible != false and " +
        "("+
        "age_to = #{session[:product_from]} " + 
        "or age_from = #{session[:product_to]} " +
        "or (age_from <= #{session[:product_to]} and age_to >= #{session[:product_from]} ) " +
        "or (age_from <= #{session[:product_from]} and age_to >= #{session[:product_to]} ) " +      
        "or (age_from >= #{session[:product_from]} and age_to <= #{session[:product_to]})" +
        ") " +
        "and (corporative_price >= #{session[:price_from].to_f*0.9} and corporative_price <= #{session[:price_to].to_f*1.1}) "
    end


    def add_to_search

      setup_values       
      
      session[:product_add] = params["q"]
      session[:product_search] = ""      
      #CHANGE THIS
      @catalogue =  Product.search('"*'+session[:product_add]+ '*"', :page => params[:page], :per_page => 20,:conditions=>{"visible"=>'1','status'=>'terminada','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")  
      @alternative = []
      #@alternative = @catalogue.first.more_like_this :field_names => [ :brand_name, :category_name ] unless @catalogue.first.nil?   
      @search = get_search_message
      respond_to do |wants|    

        wants.html {

          render :action=>:catalogo

        }


        wants.js { 
          render :update do |page|     
            page.replace_html 'search_terms', @search
            page.replace 'detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'list'    
            page << "rebind_facebox();"         
            page << "$.scrollTo('#inside',500);"   
            end

          }

        end
      end

      def set_age_from
        setup_values 
        session[:product_from] = params["q"]
        session[:product_search] = ""   
        #CHANGE THIS   
        #@catalogue =  Product.find_by_code("*", {:page => params[:page], :per_page => 20},{:conditions=>query_conditions,:order=>"created_at DESC"})  
        query_values
        @search = get_search_message
        @alternative = []
        respond_to do |wants|    

          wants.html {

            render :action=>:catalogo

          }


          wants.js { 
            render :update do |page|     
              page.replace 'detalle', :partial => 'product_list'
              page.replace_html 'search_terms', @search
              page.visual_effect :highlight, 'list'             
              page << "rebind_facebox();"   
              page << "$.scrollTo('#inside',500);"   
            end

          }

        end

      end

      def set_age_to
        
        setup_values         
        session[:product_to] = params["q"]
        session[:product_search] = ""     
        #CHANGE THIS 
        #@catalogue =  Product.find_by_code("*", {:page => params[:page], :per_page => 20},{:conditions=>query_conditions,:order=>"created_at DESC"})  
        query_values
        @alternative = []
        @search = get_search_message

        respond_to do |wants|      

          wants.html {

            render :action=>:catalogo

          }

          wants.js { 
            render :update do |page|    
              page.replace 'detalle', :partial => 'product_list'
              page.replace_html 'search_terms', @search =="" || @search==" " ? "nuestros últimos productos"  : @search
              page.visual_effect :highlight, 'list'             
              page << "rebind_facebox();"   
              page << "$.scrollTo('#inside',500);"   
            end

          }



        end

      end

      def set_age
        
        setup_values         
        session[:product_from] = params["q"]
        session[:product_to] = params["t"]
        session[:product_search] = ""
        #CHANGE THIS
        #@catalogue = Product.find_all_by_code("*", {:page => params[:page], :per_page => 20},{:conditions=>query_conditions,:order=>"created_at DESC"})           
        if session[:product_from].to_i == 0 and session[:product_to].to_i == 20

                @catalogue =  Product.search(:page=>params[:page], :per_page=>20, :conditions=>{"visible"=>'1','corporative_price'=>session[:price_from].to_i*0.9.to_i..session[:price_to].to_i*1.1.to_i,'status'=>'terminada'}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")          
                #@catalogue = Product.paginate(:all, :page=>params[:page], :per_page=>20,:conditions => ["id IN (#{catalogue_ids.join(', ')})"]) 


        else
          query_values
        end
        @alternative = []
        @search = get_search_message

        respond_to do |wants|      

          wants.html {

            render :action=>:catalogo

          }

          wants.js { 
            render :update do |page|    
              page.replace_html 'search_terms', @search
              page.replace 'detalle', :partial => 'product_list'
              page.visual_effect :highlight, 'list'    
              page << "rebind_facebox();"     
              page << "$.scrollTo('#inside',500);"                                       
            end

          }



        end

      end


      def search_product
        
        setup_values         
        if params[:product]
          @search = params["q"] || params[:product][:name] || ""
        else
          @search = params["q"] || ""
        end
        session[:product_search] = @search
        session[:product_add] = ""
        #CHANGE THIS
        @catalogue = Product.search('"*'+@search+'*"', :page => params[:page], :per_page => 20,:conditions=>{'visible'=>'1'}, :with => {:stock => 1..1000},:without => {"category_id" => "11"},:order=>"updated_at DESC")        
        @alternative = []
        @search = get_search_message
        respond_to do |wants|       
          wants.html { render :action=>:catalogo } 
          wants.js { 

            render :update do |page|
              page.replace 'detalle', :partial => 'product_list'
              page.replace_html 'search_terms', @search
              page.visual_effect :highlight, 'list'             
              page << "rebind_facebox();"   
              #page << "$.scrollTo('#inside',500);"                 
            end

          }

        end

      end



      def selectDetail
        @quote_detail = QuoteDetail.find(params[:id])
        @quote_detail.additional = false
        @quote_detail.save
        @quote = @quote_detail.quote
        @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
          is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
          @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
          ASC, age_to ASC, sex DESC")

        respond_to do |format|
          format.js  { 
            render :update do |page|
              page.remove "row_#{params[:id]}"
              page.replace "quote_partial", :partial=>'finished_quote_list'
              page.visual_effect :highlight, 'product_table'            
              page.visual_effect :fade, 'product_error'
              page.replace_html 'product_error', ""

            end

          }
        end

      end

      def destroyDetail
        @quote_detail = QuoteDetail.find(params[:id])
        @quote_detail.destroy

        @quote = Quote.find(current_quote)
        @quote_details = @quote.reload.quote_details           
        respond_to do |format|
          format.js  { 
            render :update do |page|
              page.remove "row_#{params[:id]}"
              page.visual_effect :highlight, 'product_table'            
              page.visual_effect :fade, 'product_error'
              page.replace_html 'product_error', ""
              page.replace 'consulta', :partial => 'consulta'
              page.visual_effect :highlight, 'consulta'            

            end

          }
        end

      end

    end

