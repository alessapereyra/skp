class QuotesController < ApplicationController

  skip_before_filter :is_authenticated, :only=>[:modify_quote,:modify_quotes]

  def send_quote
    begin
      @quote = Quote.find(params[:id])
      Emailer::deliver_quote_mail(@quote)
      flash[:message] = "<em>Cotizaci&oacute;n enviada correctamente</em>"
      RAILS_DEFAULT_LOGGER.error("\n Envio a cliente correcto  \n")    
      @quote.sent = true
      @quote.save            
      redirect_to quotes_report_path

    rescue Exception => ex
      flash[:message] = "<em>Error en el env&iacute;o, verifique los datos de la cotizaci&oactue;n</em>"
      RAILS_DEFAULT_LOGGER.error("\n Error en el envio  \n #{ex}  \n")                
      redirect_to edit_quote_catalogue_path(params[:id])            
    end

  end


  def setup_quote

    @pending_quotes = []
    temp = Quote.find(:all, :conditions=>"status like 'open' and id != #{current_quote}",:order=>"updated_at DESC", :include => [:client])
    temp.each do |t|
      @pending_quotes << t unless t.childless?
    end


    @quote = Quote.find(current_quote)
    @quote.document ||= Quote.last_number
    @quote.price_type = "Corporativo"
    @client_id = @quote.client_id
    session[:product_from] = 0
    session[:product_to] = 19
    session[:quote_search] ||= ""
    @products = Product.paginate(:all, :page => params[:page], :per_page => 5,:conditions=>"(status like 'terminada' or status like 'terminado') and ((age_from >= #{session[:product_from]} and age_to < #{session[:product_to]}) or (age_from IS NULL or age_to IS NULL))",:order=>"created_at DESC")       

    #@quote_detail = QuoteDetail.new
    @quote_details = @quote.quote_details

  end

  def duplicate
    @quote = Quote.find(params[:id])
    @dup_quote = Quote.new
    @dup_quote.document = Quote.last_number
    @dup_quote.price_type = "Corporativo"
    @dup_quote.store_id = get_current_store
    @dup_quote.quote_date = Time.zone.now
    @dup_quote.status ="open"
    @dup_quote.user_id = User.find_by_username(session[:logged_user]).id
    @dup_quote.updated = false
    @dup_quote.from_web = false
    @dup_quote.sent = false
    @dup_quote.save!
    session[:quote_id] = @dup_quote.id
    
    @quote.quote_details.each do |quote_detail|
      
      dup_qd = QuoteDetail.new
      dup_qd.quote_id = @dup_quote.id
      dup_qd.product_id = quote_detail.product_id
      dup_qd.quantity = quote_detail.quantity
      dup_qd.product_detail = quote_detail.product_detail
      dup_qd.from = quote_detail.from
      dup_qd.to = quote_detail.to
      dup_qd.age_from = quote_detail.age_from
      dup_qd.age_to = quote_detail.age_to
      dup_qd.price = quote_detail.price
      dup_qd.from_web = quote_detail.from_web
      dup_qd.additional = quote_detail.additional
      dup_qd.sex = quote_detail.sex
      dup_qd.pending = quote_detail.pending
      dup_qd.stock_from_almacen = 0
      dup_qd.stock_from_carisa = 0
      dup_qd.stock_from_trigal = 0
      dup_qd.stock_from_polo = 0
      dup_qd.unavailable = quote_detail.unavailable
      dup_qd.pack_number = quote_detail.pack_number
      dup_qd.save
      
    end
    
    redirect_to quotes_path
    
    
  end

  def index 

    begin

      setup_quote

    rescue Exception=> ex

      @quote = Quote.new
      @quote.document = Quote.last_number
      RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                 
      @quote_detail = QuoteDetail.new
      @quote_details = @quote.quote_details


    end

  end


  def update_quote

    Quote.transaction do 
      @quote = Quote.find(current_quote)
      @quote.document = params[:quote][:document]
      year = params[:quote][:quote_date]['year'] 
      month = params[:quote][:quote_date]['month']
      day = params[:quote][:quote_date]['day']
      @quote.quote_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @quote.client_id = params[:quote][:client_id] unless params[:quote][:client_id].blank?
      @quote.user_id = User.find_by_username(session[:logged_user]).id
      @quote.store_id = params[:quote][:store_id]
      @quote.duration = params[:quote][:duration]
      @quote.document = params[:quote][:document]
      @quote.quote_comments = params[:quote][:comments]
      @quote.sending_details = params[:quote][:sending_details]
      @quote.contact_name = params[:quote][:contact_name]
      @quote.price_type = params[:quote][:price_type]
      @quote.status = "open"
      @quote.sent = false
      if @quote.save

        render :text=>"Todo bien"

      else

        render :text=>"Error en los datos"
      end

    end #fin de transaccion
  end


  def current_quote

    if not session[:quote_id] or not Quote.exists?(session[:quote_id])

      @quote = Quote.new      
      if params[:quote]
        @quote.store_id = params[:quote][:store_id]
      end
      @quote.store_id = get_current_store
      @quote.quote_date = Time.zone.now
      @client_id = @quote.client_id
      @quote.status ="open"
      @quote.user_id = User.find_by_username(session[:logged_user]).id
      @quote.updated = false
      @quote.from_web = false
      @quote.sent = false
      @quote.save!

      age_range = AgeRange.new
      age_range.masculine = 0
      age_range.femenine = 0
      age_range.from_web = false
      age_range.save

      @quote.age_ranges << age_range

      session[:quote_id] = @quote.id

    end

    return session[:quote_id]

  end

  def modify_quote

    
    if params[:quote_detail]
      params[:quote_detail].each do |id,line|
        begin
        quote_detail = QuoteDetail.find(id)
        quote_detail.from_web = true
        quote_detail.update_attributes(line)
        @quote = quote_detail.quote
        rescue Exception => ex
          RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                 
        end
      end
    end

    if params[:age_range]
      params[:age_range].each do |id,line|
        age_range = AgeRange.find(id)
        age_range.from_web = true
        age_range.update_attributes(line)
      end
    end

    if @quote
      @quote.updated = true 
      @quote.save 
    else
      @quote = Quote.find(params[:id])
    end
      redirect_to "/web/cotizaciones/#{Base64.encode64(@quote.sending_details)}"

  end

  def update_quote_details


    if params[:quote_detail]
      params[:quote_detail].each do |id,line|
        quote_detail = QuoteDetail.find(id)
        quote_detail.from_web = false
        quote_detail.update_attributes(line)
        @quote = quote_detail.quote
      end
    end

    respond_to do |wants|

      wants.js { 
        render :update do |page|
          @quote_details = @quote.quote_details
          page.replace 'producto_detalle', :partial => 'product_list'
          page.visual_effect :highlight, 'product_table'            
          page.visual_effect :fade, 'product_error'
          page.replace_html 'product_error', ""                                    
        end

      }

    end  # respond



  end

  def print_quote
    @quote = Quote.find(params[:id])
    @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
      is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
      @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
      ASC, age_to ASC, sex DESC")


      render :layout=>"print_pages"
    end


    def quote_detail_price(quote_detail,price_type,product)

      if quote_detail.price.blank?

        price_type = "Corporativo" if price_type.blank?

        price_index = if price_type == "Mayorista"
          2
        elsif price_type == "Corporativo"
          1
        else
          2 + get_current_store
        end

        price = (product.all_current_prices[price_index])
        price = Price.new({:amount=> 0.0}) if price.blank?

        price.amount

      else
        quote_detail.price 
      end

    end



    def add_to_quote

      QuoteDetail.transaction do    

        error = ""
        @qd = QuoteDetail.new
        @qd.quote_id = current_quote
        @qd.product_id = params[:id]
        @qd.quantity = 1
        @qd.age_from = @qd.product.age_from
        @qd.age_to = @qd.product.age_to
        @qd.sex = case @qd.product.sex
        when "masculino"
          "h"
        when "femenino"
          "m"
        else
          "hm"
        end
        @qd.from_web = false
        @quote = @qd.quote      
        @quote.price_type ||= "Corporativo"
        @quote.save
        @qd.save
        @qd.price = quote_detail_price(@qd,@quote.price_type,@qd.product)

=begin
        #      quote.price_type = params[:price_type]
        #      quote.save!
        #      @quote = @qd.quote

        year = params[:quote]["quote_date(1i)"] 
        month = params[:quote]["quote_date(2i)"] 
        day = params[:quote]["quote_date(3i)"]
        @quote.quote_date = Time.zone.parse("#{year}-#{month}-#{day}")  
        @quote.client_id =  params[:quote][:hidden_client_id].blank? ? params[:quote][:client_id] : params[:quote][:hidden_client_id] unless (params[:quote][:hidden_client_id].blank? or params[:quote][:client_id].blank?)
        @quote.client_address = @quote.client.address unless @quote.client.blank?
        @quote.document = Quote.last_number
        @quote.price_type = params[:quote][:price_type]
        @quote.sending_details = params[:quote][:sending_details]
        @quote.contact_name = params[:quote][:contact_name]
        @quote.duration = params[:quote][:duration]
        @quote.quote_comments = params[:quote][:quote_comments]
        @quote.status ="accepted"
        @quote.sent = false
=end      
        @quote.updated = false

        @quote.save

=begin



        price_index = if params[:quote][:price_type] == "Mayorista"
          2
        elsif params[:quote][:price_type] == "Corporativo"
          1
        else
          1 + get_current_store
        end


        @qd.price = @qd.product.all_current_prices[price_index].amount
=end    
        begin
          if @qd.save!
            @quote = @qd.quote
            
            respond_to do |wants|

              wants.js { 

                render :update do |page|

                  @quote_details = @quote.reload.quote_details    
                  page.replace 'producto_detalle', :partial => 'product_list'
                  page.visual_effect :highlight, 'product_table'            
                  page.visual_effect :fade, 'product_error'
                  page.replace_html 'product_error', ""                                    
                  #clean_form            
                end

              }

            end  # respond



          end  #save



        rescue Exception => ex

          respond_to do |wants|

            wants.js {

              render :update do |page|                 
                error ||= "Algunos parámetros del producto están vacíos o incorrectos."
                RAILS_DEFAULT_LOGGER.error("\n #{ex}  \n")                
                page.visual_effect :show, 'product_error'    
                page.replace_html 'product_error', "<em id='new_product_error'>Error: #{error || ex }</em>"

                page.visual_effect :highlight, 'new_product_error'             
              end

            }

          end  #respond

        end  #rescue


      end #transaction

    end

    def add_product

      QuoteDetail.transaction do 

        error = ""
        @qd = QuoteDetail.new
        @qd.quote_id = current_quote
        @qd.product_id = params[:quote_detail][:hidden_product_id]
        @qd.quantity = params[:quote_detail][:quantity]
        @qd.price = params[:quote_detail][:price]
        @qd.sex = params[:quote_detail][:sex]
        @qd.from_web = false
        @quote = @qd.quote
        begin 

          if @qd.quantity > @qd.product.store_stock(get_current_store)
            error = "No existe stock suficiente"
            raise
          end


          year = params[:quote]["quote_date(1i)"] 
          month = params[:quote]["quote_date(2i)"] 
          day = params[:quote]["quote_date(3i)"]
          @quote.quote_date = Time.zone.parse("#{year}-#{month}-#{day}")  
          @quote.client_id =  params[:quote][:hidden_client_id].blank? ? params[:quote][:client_id] : params[:quote][:hidden_client_id] unless (params[:quote][:hidden_client_id].blank? or params[:quote][:client_id].blank?)
          @quote.client_address = @quote.client.address unless @quote.client.blank?
          @quote.document = Quote.last_number
          @quote.price_type = params[:quote][:price_type]
          @quote.sending_details = params[:quote][:sending_details]
          @quote.contact_name = params[:quote][:contact_name]
          @quote.duration = params[:quote][:duration]
          @quote.quote_comments = params[:quote][:quote_comments]
          @quote.status ="accepted"
          @quote.sent = false
          @quote.updated = false
          @quote.save


          if @qd.save!

            respond_to do |wants|

              wants.js { 

                render :update do |page|

                  @quote_details = @qd.quote.quote_details
                  page.replace 'detalle', :partial => 'product_list'
                  page.visual_effect :highlight, 'product_table'            
                  page.visual_effect :fade, 'product_error'
                  page.call('clean_forms')
                  page.replace_html 'product_error', ""                                    
                  #clean_form            
                end

              }

            end  # respond



          end  #save




        rescue Exception => ex

          respond_to do |wants|

            wants.js {

              render :update do |page|                 
                error ||= "Algunos parámetros del producto están vacíos o incorrectos."
                RAILS_DEFAULT_LOGGER.error("\n #{ex}  \n")                
                page.visual_effect :show, 'product_error'    
                page.replace_html 'product_error', "<em id='new_product_error'>Error: #{error || ex }</em>"

                page.visual_effect :highlight, 'new_product_error'             
              end

            }

          end  #respond

        end  #rescue


      end #transaction

    end


    def edit
      create
    end

    def update
      create
    end

    def mark_as_read
      @quote = Quote.find(params[:id])
      @quote.mark_as_read
      redirect_to quotes_report_path
    end

    def create

      Quote.transaction do 

        @quote = Quote.find(current_quote)
        year = params[:quote]["quote_date(1i)"] 
        month = params[:quote]["quote_date(2i)"] 
        day = params[:quote]["quote_date(3i)"]
        @quote.quote_date = Time.zone.parse("#{year}-#{month}-#{day}")  
        @quote.client_id =  params[:quote][:hidden_client_id].blank? ? params[:quote][:client_id] : params[:quote][:hidden_client_id]
        @quote.client_address = @quote.client.address unless @quote.client.blank?
        @quote.document = params[:quote][:document]
        @quote.price_type = params[:quote][:price_type]
        @quote.sending_details = params[:quote][:sending_details]
        @quote.contact_name = params[:quote][:contact_name]
        @quote.duration = params[:quote][:duration]
        @quote.quote_comments = params[:quote][:quote_comments]
        @quote.status ="accepted"
        @quote.sent = false
        @quote.updated = false


        if @quote.valid?
          @quote.save!


          if @quote.quote_details.empty?

            flash[:error]="<em>No ha ingresado ningún producto</em>"
            @quote_details =  []
            render :action=>:index
          else

            params[:quote_detail].each do |id,line|
              quote_detail = QuoteDetail.find(id)
              quote_detail.from_web = false
              #quote_detail.update_attributes(line)

=begin               price_index = case @quote.price_type
              when "Mayorista"
                2
              when "Corporativo"
                1
              else
                2 + get_current_store
              end


              quote_detail.price = quote_detail.product.all_current_prices[price_index].amount

              quote_detail.save
=end          
            end

            session[:quote_id] = nil         
            flash[:message] = "<em>Orden de Salida registrada exitosamente. <a href='/sending'>Generar una nueva</a></em>"

            if @quote.is_requested
              redirect_to :action=>"as_request",:id=>@quote.id
            else
              redirect_to quote_report_path(@quote.id)
            end

          end #esta vacio
        else
          flash[:error]="<em>Error en la orden</em>"

          @pending_quotes = []
          temp = Quote.find(:all, :conditions=>"status like 'open' and id != #{current_quote} and store_id=#{get_current_store}")
          temp.each do |t|
            @pending_quotes << t unless t.childless?
          end

          setup_quote

          render :action=>:index
        end   # valida

      end #fin transacción

    end

    def destroyDetail
      @quote_detail = QuoteDetail.find(params[:id])
      @quote_detail.destroy

      @quote = Quote.find(current_quote)
      @quote_details = @quote.quote_details           
      respond_to do |format|
        format.js  { 
          render :update do |page|
            page.replace 'producto_detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'product_table'            
            page.visual_effect :fade, 'product_error'
            page.replace_html 'product_error', ""

          end

        }
      end

    end


    def recover
      session[:quote_id] = params[:id]
      @quote = Quote.find(params[:id])
      @quote.updated = false
      @quote.status = "open"
      @quote.sent = false
      @quote.save
      redirect_to quotes_path
    end

    def recover_to_quote
      session[:quote_id] = params[:id]
      @quote = Quote.find(params[:id])
      @quote.updated = false
      @quote.is_requested = true
      @quote.status = "open"
      @quote.sent = false
      @quote.orders_generated = false

      #se convierte de nuevo en cotización, se devuelve el stock
      @quote.quote_details.each do |quote_detail|

        quote_detail.return_stock

      end

      @quote.save
      redirect_to quotes_path
    end



    def to_quote
      @quote = Quote.find(params[:id])
      @quote.status = "accepted"
      @quote.is_requested = false
      @quote.orders_generated = false

      #se convierte de nuevo en cotización, se devuelve el stock
      @quote.quote_details.each do |quote_detail|

        quote_detail.return_stock

      end

      @quote.save
      redirect_to quote_report_path(@quote.id)

    end

    def destroy

      Quote.transaction do

        @quote =   Quote.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
        #como la orden AÚN no se ha terminado, el stock no se toca

        @quote.quote_details.each do |sod|


          sod.destroy                             #eliminamos el detalle orden

        end


        @quote.destroy                          #finalmente eliminamos la orden

        last_order = Quote.find(:all, :conditions=>"status like 'open' and id != #{current_quote} and store_id=#{get_current_store}", :order=>'created_at DESC', :limit=>1)
        session[:quote_id] = last_order.id

        redirect_to quotes_path


      end

    end

    def update_ranges

      params[:age_range].each do |id,line|
        age_range = AgeRange.find(id)
        age_range.from_web = false
        age_range.update_attributes(line)
        @quote = age_range.quote
      end



      respond_to do |format|
        format.js  { 
          render :update do |page|

            page.replace 'quote_detalle', :partial => 'ranges'
            page.visual_effect :highlight, 'range_table'            
            page.visual_effect :fade, 'product_error'
            page.replace_html 'product_error', ""

          end

        }
      end

    end

    def new_range

      if params[:age_range]
        params[:age_range].each do |id,line|
          age_range = AgeRange.find(id)
          age_range.from_web = false
          age_range.update_attributes(line)
        end
      end

      age_range = AgeRange.new
      age_range.quote_id = current_quote
      age_range.from_web = false
      age_range.save
      respond_to do |format|
        format.js  { 
          render :update do |page|
            @quote = age_range.quote
            page.replace 'quote_detalle', :partial => 'ranges'
            page.visual_effect :highlight, 'range_table'            
            page.visual_effect :fade, 'product_error'
            page.replace_html 'product_error', ""

          end

        }
      end


    end

    def destroyRange

      AgeRange.transaction do

        age_range =   AgeRange.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
        #como la orden AÚN no se ha terminado, el stock no se toca

        @quote = age_range.quote  
        age_range.destroy                          #finalmente eliminamos la orden

        respond_to do |format|
          format.js  { 
            render :update do |page|
              page.replace 'quote_detalle', :partial => 'ranges'
              page.visual_effect :highlight, 'range_table'            
              page.visual_effect :fade, 'product_error'
              page.replace_html 'product_error', ""

            end

          }
        end


      end

    end


    def destroyWeb

      Quote.transaction do

        @quote =   Quote.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
        #como la orden AÚN no se ha terminado, el stock no se toca

        @quote.quote_details.each do |sod|


          sod.destroy                             #eliminamos el detalle orden

        end


        @quote.destroy                          #finalmente eliminamos la orden

        last_order = Quote.find(:all, :conditions=>"status like 'open' and id != #{current_quote} and store_id=#{get_current_store}", :order=>'created_at DESC', :limit=>1)
        session[:quote_id] = last_order.id

        redirect_to quotes_from_web_path


      end

    end



    def from_web

      @web_quotes = []
      temp = Quote.find(:all, :conditions=>"from_web is true and status is null")
      temp.each do |t|
        @web_quotes << t unless t.childless?
      end


    end

    def save_quote
      @quote = Quote.find(params[:id])
      year = params[:quote]["quote_date(1i)"] 
      month = params[:quote]["quote_date(2i)"] 
      day = params[:quote]["quote_date(3i)"]
      @quote.quote_date = Time.zone.parse("#{year}-#{month}-#{day}")
      @quote.store_id = params[:quote][:store_id]
      @quote.client_id = params[:quote][:hidden_client_id]
      @quote.client_id = params[:quote][:hidden_client_id]
      @quote.document = params[:quote][:document]
      @quote.price_type = params[:quote][:price_type]
      @quote.sending_details = params[:quote][:sending_details]
      @quote.contact_name = params[:quote][:contact_name]
      @quote.duration = params[:quote][:duration]
      @quote.quote_comments = params[:quote][:quote_comments]
      @quote.status ="accepted"


      if @quote.valid?
        @quote.save!

        params[:quote_details].each do |qd,params|
          quote_detail = QuoteDetail.find(qd)
          quote_detail.from_web = false
          quote_detail.update_attributes(params)
        end
      end
      
      
      begin
        Emailer::deliver_quote_mail(@quote)
        flash[:message] = "<em>Cotizaci&oacute;n enviada correctamente</em>"
        RAILS_DEFAULT_LOGGER.error("\n Envio a cliente correcto  \n")    
        @quote.sent = true
        @quote.save            
        redirect_to quotes_from_web_path
        
      rescue Exception => ex
        flash[:message] = "<em>Error en el env&iacute;o, verifique los datos de la cotizaci&oactue;n</em>"
        RAILS_DEFAULT_LOGGER.error("\n Error en el envio  \n #{ex}  \n")                
        redirect_to edit_quote_catalogue_path(params[:id])            
      end


    end

    def review
      @quote = Quote.find(params[:id])
    end

    def set_age_from
      session[:product_from] = params["q"]
      query_values
      respond_to do |wants|    

        wants.html {
          setup_quote
          render :action=>:index

        }


        wants.js { 
          render :update do |page|
            #CHANGE THIS
            #@products =  Product.search("*"+session[:quote_search]+"*", {:page => params[:page], :per_page => 5},{:conditions=>"(status like 'terminada' or status like 'terminado') and ((age_from >= #{session[:product_from]} and age_to < #{session[:product_to]}) or (age_from IS NULL or age_to IS NULL))",:order=>"created_at DESC"})       

            page.replace 'detalle', :partial => 'detail'
            page.visual_effect :highlight, 'list'                
          end

        }

      end

    end

    def set_age_to
      session[:product_to] = params["q"]
      query_values
      respond_to do |wants|      

        wants.html {
          setup_quote
          render :action=>:index

        }

        wants.js { 
          render :update do |page|
            #CHANGE THIS
            #@products =  Product.find_all_by_code("*"+session[:quote_search]+"*", {:page => params[:page], :per_page => 5},{:conditions=>"(status like 'terminada' or status like 'terminado') and ((age_from >= #{session[:product_from]} and age_to < #{session[:product_to]}) or (age_from IS NULL or age_to IS NULL))",:order=>"created_at DESC"})       
            
            page.replace 'detalle', :partial => 'detail'
            page.visual_effect :highlight, 'list'                
          end

        }



      end

    end


    def query_values
        catalogue_ids = []
        ids = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','age_to'=>session[:product_from]},:order=>"updated_at DESC")          
        ids2 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','age_from'=>session[:product_to]},:order=>"updated_at DESC")          
        ids3 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','age_from'=>0..session[:product_to].to_i,'age_to'=>session[:product_from].to_i..20},:order=>"updated_at DESC")          
        ids4 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','age_from'=>0..session[:product_from].to_i,'age_to'=>session[:product_to].to_i..20},:order=>"updated_at DESC")          
        ids5 = Product.search_for_ids(:conditions=>{"visible"=>'1','status'=>'terminada','age_from'=>session[:product_from].to_i..20,'age_to'=>0..session[:product_to].to_i},:order=>"updated_at DESC")          
        ids.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids2.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids3.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids4.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }
        ids5.each {|i| catalogue_ids << i unless catalogue_ids.include? i or i.blank? }                  
        @products = Product.paginate(:all, :page=>params[:page], :per_page=>20,:conditions => ["id IN (#{catalogue_ids.join(', ')})"]) 
    end

    def as_request

      @quote = Quote.find(params[:id])
      status = @quote.status
      @quote.status = "requested"
      @quote.store_id =  3 #get_current_store  # por defecto deberia ser almacen para todos?
      @quote.is_requested = true
      @quote.save

      @quote.quote_details.each do |quote_detail|

        quote_detail.additional = false
        quote_detail.save 
        
        unless status == "requested"
          quote_detail.unload_stock
        end
      end

    #end

    @quote.save
    redirect_to quote_request_report_path(@quote.id)
  end   

  def to_sending_guide

    @quote = Quote.find(params[:id])
    if @quote

      Quote.transaction do
        sending_guide = SendingGuide.new
        sending_guide.status = "open"
        sending_guide.store_id = get_current_store
        sending_guide.client_id = @quote.client_id
        sending_guide.unload_stock = false
        sending_guide.sending_date = Time.zone.now
        sending_guide.document = "De Cotización #{@quote.document}"
        sending_guide.save

        @quote.quote_details.final.each do |quote_detail|

          sending_guide_detail = SendingGuideDetail.new
          sending_guide_detail.convert(quote_detail)
          sending_guide_detail.status = "open"
          sending_guide_detail.price = quote_detail.price
          sending_guide_detail.pending = sending_guide_detail.quantity
          sending_guide_detail.sending_guide_id = sending_guide.id
          sending_guide_detail.save
        end

        if @quote.valid?

          session[:sending_guide_id] = sending_guide.id
          redirect_to sending_guides_path


        end
      end #transaction

    end

  end


  def generate_orders

    @quote = Quote.find(params[:id])      

    unless @quote.orders_generated

      max_items_per_order = 10.0

      Order.transaction do

        total_items = @quote.quote_details.final.size   # 36
        orders = (total_items / max_items_per_order).ceil
        @quote.orders_generated = true
        @quote.save 

        i = 0
        count = 0
        orders.times do 

          order = Order.new
          order.status = "open"
          order.type = "factura"
          order.unload_stock = false
          order.number = Order.last_number_of("factura",get_current_store)+count
          order.store_id = get_current_store
          order.client_id = @quote.client_id
          order.quote_id = @quote.id
          order.address = order.client.address unless order.client.blank?
          order.order_date = Time.zone.now
          order.save
          count += 1

          if total_items > max_items_per_order

            total_times = total_items - max_items_per_order

            max_items_per_order.to_i.times do

              order_detail = OrderDetail.new
              order_detail.convert(@quote.quote_details.final[i])
              order_detail.order_id = order.id
              order_detail.save           
              i += 1   

            end # times

          else


            total_items.times do
              order_detail = OrderDetail.new
              order_detail.convert(@quote.quote_details.final[i])
              order_detail.order_id = order.id
              order_detail.save           
              i += 1   
            end            

            total_items = 0              
            @quote.save

          end  #times
          order.recalculate_total
        end # times


      end  #transaction

    end #unless


  end


  def to_order

    @quote = Quote.find(params[:id])
    if @quote

      Quote.transaction do
        order = Order.new
        order.status = "open"
        order.type = "factura"
        order.unload_stock = false
        order.number = Order.last_number_of("factura",get_current_store)
        order.store_id = get_current_store
        order.client_id = @quote.client_id
        order.address = order.client.address unless order.client.blank?
        order.order_date = Time.zone.now
        order.save

        @quote.quote_details.each do |quote_detail|

          order_detail = OrderDetail.new
          order_detail.convert(quote_detail)
          order_detail.order_id = order.id
          order_detail.save
        end

        order.recalculate_total

        if @quote.valid?

          session[:order_id] = order.id
          redirect_to orders_path


        end #valid
      end

    end #quote valid



  end   


  def search_product

    setup_quote
		discover_products

    respond_to do |wants|         
      wants.html {
        render :action=>:index

      }


      wants.js { 
        session[:quote_search] = params["q"]
        render :update do |page|
          #CHANGE THIS
     #     @products =  Product.find_all_by_code("*"+session[:quote_search]+"*", {:page => params[:page], :per_page => 5},{:conditions=>"(status like 'terminada' or status like 'terminado') and ((age_from >= #{session[:product_from]} and age_to < #{session[:product_to]}) or (age_from IS NULL or age_to IS NULL))",:order=>"created_at DESC"})       
          page.replace 'detalle', :partial => 'detail'
          page.visual_effect :highlight, 'list'                
        end

      }

    end

  end

	private
	
	
	def discover_products
		@products = Product.search('"*'+session[:quote_search]+'*"', :page => params[:page], :per_page => 20,:conditions=>{'status'=>'terminada'},:order=>"updated_at DESC")        
    
	end


end
