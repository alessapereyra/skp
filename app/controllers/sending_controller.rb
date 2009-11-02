class SendingController < ApplicationController

  before_filter :no_cache


  	def index 

    @pending_send_orders = []
    temp = SendOrder.find(:all, :conditions=>"status like 'open' and id != #{current_send_order} and owner_id=#{get_current_store}")
    temp.each do |t|
      @pending_send_orders << t unless t.childless?
    end
    
    begin
      @send_order = SendOrder.find(current_send_order)

      @send_order_detail = SendOrderDetail.new
      @send_order_details = session[:send_order_id] ? SendOrder.find(session[:send_order_id]).send_order_details  : []
    rescue

      @send_order = SendOrder.new

      @send_order_detail = SendOrderDetail.new
      @send_order_details = @send_order.send_order_details

     
    end

  end


  def update_send_order

    SendOrder.transaction do 
      @send_order = SendOrder.find(current_send_order)
      @send_order.document = params[:send_order][:document]

      year = params[:send_order][:send_date]['year'] 
      month = params[:send_order][:send_date]['month']
      day = params[:send_order][:send_date]['day']
      @send_order.send_date = Time.zone.parse("#{year}-#{month}-#{day}")
      
      @send_order.store_id = params[:send_order][:store_id]
      @send_order.owner_id = params[:send_order][:owner_id]
      @send_order.status = "open"
      if @send_order.save

        render :text=>"Todo bien"

      else

        render :text=>"Error en los datos"
      end

    end #fin de transaccion
  end

  def current_send_order

    if not session[:send_order_id] or not SendOrder.exists?(session[:send_order_id])

      @send_order = SendOrder.new      
      if params[:send_order]
        @send_order.store_id = params[:send_order][:store_id]
        @send_order.owner_id = params[:send_order][:owner_id]
      end
      @send_order.owner_id ||= get_current_store
      @send_order.store_id ||= 1
      @send_order.send_date = Time.zone.now
      @send_order.status ="open"
      @send_order.save!
      session[:send_order_id] = @send_order.id

    end

    return session[:send_order_id]

  end


  def add_product

    SendOrderDetail.transaction do 

      @sod = SendOrderDetail.new
      @sod.send_order_id = current_send_order
      @sod.product_id = params[:send_order_detail][:hidden_product_id]
      @sod.quantity = params[:send_order_detail][:quantity]
      @send_order = @sod.send_order
      begin 

    
     if @sod.quantity > Product.find(@sod.product_id).store_stock(get_current_store)
         error = "<em id='new_product_error'>No existe stock suficiente del producto.</em>"
         raise
    end
   
        if @sod.save!

          respond_to do |wants|

            wants.js { 

              render :update do |page|

                @send_order_details = @sod.send_order.send_order_details

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
              RAILS_DEFAULT_LOGGER.error("\n #{ ex}  \n")                
              page.visual_effect :show, 'product_error'    
              page.replace_html 'product_error', error ||  "<em id='new_product_error'>Algunos parámetros del producto están vacíos o incorrectos.</em>"
              
              page.visual_effect :highlight, 'new_product_error'             
            end

          }

        end  #respond

      end  #rescue


      end #transaction

    end

    def update
      create
    end

    def create

      SendOrder.transaction do 

        @send_order = SendOrder.find(current_send_order)
        year = params[:send_order]["send_date(1i)"] 
        month = params[:send_order]["send_date(2i)"] 
        day = params[:send_order]["send_date(3i)"]
        @send_order.send_date = Time.zone.parse("#{year}-#{month}-#{day}")
        @send_order.store_id = params[:send_order][:store_id]
        @send_order.owner_id = params[:send_order][:owner_id]
        @send_order.document = params[:send_order][:document]
        @send_order.status ="pending"


        if @send_order.valid?
          @send_order.save!



          if (not params[:send_order_detail][:hidden_product_id].empty?) && (not params[:send_order_detail][:quantity].empty?)
            @sod = SendOrderDetail.new
            @sod.product_id = params[:send_order_detail][:hidden_product_id].to_i
            @sod.quantity = params[:send_order_detail][:quantity].to_i
            @sod.send_order_id = current_send_order
            @sod.save!
          end   # no hay sod pendiente


          if @send_order.send_order_details.empty?

            flash[:error]="<em>No ha ingresado ningún producto</em>"
            @send_order_details =  []
            render :action=>:index
          else

            @send_order.send_order_details.each do |sod|

            #  if @send_order.unload_stock or @send_order.unload_stock.nil?
                sod.product.update_stock(sod.quantity*-1) unless sod.product.nil?
                sod.product.update_store_stock(sod.quantity*-1,@send_order.owner_id,self.class,this_method_name) unless sod.product.nil?
                sod.product.unload_if_pending
            #  end
            end  # each

            session[:send_order_id] = nil         
            flash[:message] = "<em>Orden de Salida registrada exitosamente. <a href='/sending'>Generar una nueva</a></em>"


            redirect_to send_order_report_path(@send_order.id)

          end #esta vacio
        else
          flash[:error]="<em>Error en la orden</em>"
          render :action=>:index
        end   # valida

      end #fin transacción

    end

    def destroyDetail
      @send_order_detail = SendOrderDetail.find(params[:id])
      @send_order_detail.destroy
      @send_order = SendOrder.find(current_send_order)
      respond_to do |format|
        format.js  { 
          render :update do |page|
            @send_order_details = @send_order.send_order_details           
            page.replace 'detalle', :partial => 'product_list'
            page.visual_effect :highlight, 'product_table'            
            page.visual_effect :fade, 'product_error'
            page.call('clean_forms')
            page.replace_html 'product_error', ""

          end

        }
      end

    end


     def recover
        session[:send_order_id] = params[:id]
        
        
        io = SendOrder.find(params[:id])

        if io.status == "accepted" or io.status == "pending"
            io.send_order_details.each do |sod|   # cuando se reabre la orden de envio, se devuelve el stock


              sod.product.update_stock(sod.quantity)
              sod.product.update_store_stock(sod.quantity,io.owner_id,self.class,this_method_name)

                  if io.status == "accepted"        # si ya habia sido aceptada, se quita el stock de la tienda receptora
                    sod.product.update_store_stock(sod.quantity*-1,io.store_id,self.class,this_method_name)              
                  end


            end
        end #si estaba cerrada

        io.status = "open"
                
                
        redirect_to send_orders_path
      end

      def destroy

         SendOrder.transaction do

           @send_order =   SendOrder.find(params[:id])  #obtenemos la orden a eliminar y luego eliminamos todos sus detalles
                                               #como la orden AÚN no se ha terminado, el stock no se toca

             @send_order.send_order_details.each do |sod|

               
                 sod.destroy                             #eliminamos el detalle orden

             end


           @send_order.destroy                          #finalmente eliminamos la orden

           last_order = SendOrder.find(:all, :conditions=>"status like 'open' and id != #{current_send_order} and store_id=#{get_current_store}", :order=>'created_at DESC', :limit=>1)
           session[:send_order_id] = last_order.id

               redirect_to send_orders_path


         end

       end

  end
