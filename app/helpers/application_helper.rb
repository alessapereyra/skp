# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def errors_for(object)
    
    if object.errors.count > 0
    
    content_tag(:div,"Hubieron algunos errores en la creación"  <<
    content_tag(:ul,object.errors.full_messages.map{ |msg| content_tag(:li,msg)}),:class=>"errors")
    
  end
  end
  
  def active?(option,controller)
    
    mapping = {:buying_orders=>"buying_orders"}
    option = mapping[option.to_sym] if mapping.keys.include?(option.to_sym)
    
    
    
    option==controller
    
    
    
  end
  
  def display_provider_codes(product)
    result = ""
    product.provider_codes.each {|t| result << content_tag(:div, t) unless t.nil? or t == "" }

    result
  
  end
  
  def extra_options(option,controller)
    active?(option,controller) ? {:class=>"active"} : {}
  end
  
  
  def codify(price)
    
    price = price.to_s

  #  code = %w(D C U M B E R L A N )
  # code =    0 1 2 3 4 5 6 7 8 9
    code = %w(O J U S T I M E A N )
    
    0..10.times do |i|

      price.gsub!(i.to_s,code[i])       
      
    end

=begin
    price.gsub!('0','D') 
    price.gsub!('1','C')
    price.gsub!('2','U')
    price.gsub!('3','M')
    price.gsub!('4','B')
    price.gsub!('5','E')                
    price.gsub!('6','R')
    price.gsub!('7','L')
    price.gsub!('8','A')
    price.gsub!('9','N')
=end

    natural,decimal = price.split(".")
    
    #if decimal.length == 1 
    #  price << code[0]
    #end
     
    if (decimal == code[0]) || (decimal == code[0]+code[0])
        natural
    else
        price
    end  
            
                   
  end
  
  def print_store_price(product,store)
      product.store_price(store).round(2)
  end
  
  def change_sex(sex)
    
    if sex == "masculino"
      "h"
    elsif sex == "unisex"
      "hm"  
    elsif sex == "femenino"
      "m"
    else
      "hm"
    end
  end
  
  def fill_zero(number)
    t = number.to_s
    numero,decimal = t.split(".")
    unless decimal.nil?
      if decimal.length == 1
        decimal += "0"
      end
      numero + "." + decimal
    else
      number
    end
    
  end
  
  def price(detail,number)
    if detail.blank?
      0.00
    else

      result = nil
      
      case number
        when 0
          result = detail.base_price
        when 1
          result = detail.wholesale_price
        when 2
          result = detail.corporative_price
        when 3
          result = detail.trigal_price
        when 4
          result = detail.polo_price
      end
      result.blank? ? 0 : result.amount     

  end
  end
  
  def current_store
    session[:current_store_id]
  end
  
  def logged?
    session[:logged_user] != nil
  end
  
  def storage?
    session[:user_storage] ||= (User.find_by_username(session[:logged_user]).storage? unless session[:logged_user].blank?)
  end
  
  def store?
    session[:user_store] ||= (User.find_by_username(session[:logged_user]).store? unless session[:logged_user].blank?)
  end
  
  
  def admin?
   session[:user_admin] ||= User.find_by_username(session[:logged_user]).admin?
  end

  def store_supervisor?
    session[:user_supervisor] ||= User.find_by_username(session[:logged_user]).store_supervisor?
  end
  
  def store_admin?
    session[:user_store_admin] ||= User.find_by_username(session[:logged_user]).store_admin?
  end
  
  def salesclerk?
    session[:user_salesclerk] ||= User.find_by_username(session[:logged_user]).salesclerk?
  end
  
  def menues_for(controller)

     if ['admin_exit_orders','categories','products','clients','stores','units','providers','input_orders','brands','send_orders','orders','admin_send_orders'].include?(controller)

     content_tag(:ul, ""<< 
     content_tag(:li, (link_to "productos", products_path, extra_options("products",controller))) <<
     content_tag(:li, (link_to "ingresos", input_orders_catalogue_path,extra_options("input_orders",controller))) <<#<<
     content_tag(:li, (link_to "traslados", send_orders_catalogue_path,extra_options("send_orders",controller))) <<#<<     
     content_tag(:li, (link_to "envios", admin_sending_guides_catalogue_path,extra_options("admin_sending_guides",controller))) <<#<<          
     content_tag(:li, (link_to "ordenes salida", admin_exit_orders_catalogue_path,extra_options("admin_exit_orders",controller))) <<#<<          
     content_tag(:li, (link_to "ventas", orders_catalogue_path,extra_options("orders",controller))) <<#<<          
     content_tag(:li, (link_to "categorias", categories_path,extra_options("categories",controller))) <<
     content_tag(:li, (link_to "clientes", clients_path,extra_options("clients",controller))) <<
     content_tag(:li, (link_to "marcas", brands_path,extra_options("brands",controller))) <<
     content_tag(:li, (link_to "proveedores", providers_path,extra_options("providers",controller))) <<
     content_tag(:li, (link_to "tiendas", stores_path,extra_options("stores",controller))))

#     content_tag(:li, (link_to "unidades", units_path,extra_options("units",controller))))     


   elsif "inventory" == controller

    content_tag(:ul, ""<< 
    content_tag(:li, (link_to "etiquetas", tags_path,extra_options("inventory",controller))))

  elsif "catalogue" == controller

    if store?
      content_tag(:ul, ""<< 
      content_tag(:li, (link_to "productos", catalogue_path,extra_options("inventory",controller))))   

    elsif salesclerk?
    
      content_tag(:ul, ""<< 
      content_tag(:li, (link_to "productos", catalogue_path,extra_options("inventory",controller))) <<
      content_tag(:li, (link_to "clientes", clients_catalogue_path,extra_options("clients",controller))) <<
      content_tag(:li, (link_to "mail a clientes", send_mails_path,extra_options("catalogue",controller))))
    
    
  elsif (admin? or store_admin? or store_supervisor?)
    content_tag(:ul, ""<< 
    content_tag(:li, (link_to "productos", catalogue_path,extra_options("inventory",controller))) <<
    content_tag(:li, (link_to "proveedores", providers_catalogue_path,extra_options("providers",controller))) <<               
    content_tag(:li, (link_to "clientes", clients_catalogue_path,extra_options("clients",controller))) <<
    content_tag(:li, (link_to "mail a clientes", send_mails_path,extra_options("catalogue",controller))))
    
  end

   elsif ['sending','sending_guides'].include? controller

     if salesclerk?
       content_tag(:ul, ""<< 
       content_tag(:li, (link_to "traslado",sending_path ,extra_options("sending",controller))) <<
       content_tag(:li, (link_to "perdida",perdida_path ,extra_options("sending_guides",controller))) <<
       content_tag(:li, (link_to "mal estado",mal_estado_path ,extra_options("sending_guides",controller))) <<
       content_tag(:li, (link_to "consumo interno",consumo_interno_path ,extra_options("sending_guides",controller))) <<       
       content_tag(:li, (link_to "consumo externo",consumo_externo_path ,extra_options("sending_guides",controller))) <<
       content_tag(:li, (link_to "devolucion",devolucion_path ,extra_options("sending_guides",controller))))
     else
       content_tag(:ul, ""<< 
       content_tag(:li, (link_to "traslado",sending_path ,extra_options("sending",controller))) <<
       content_tag(:li, (link_to "perdida",perdida_path ,extra_options("sending_guides",controller))) <<
       content_tag(:li, (link_to "mal estado",mal_estado_path ,extra_options("sending_guides",controller))) <<
       content_tag(:li, (link_to "consumo interno",consumo_interno_path ,extra_options("sending_guides",controller))) <<       
       content_tag(:li, (link_to "consumo externo",consumo_externo_path ,extra_options("sending_guides",controller))) <<       
       content_tag(:li, (link_to "devolucion",devolucion_path ,extra_options("sending_guides",controller))) <<  
       content_tag(:li, (link_to "env&iacute;os a clientes", sending_guides_path,extra_options("sending_guides",controller))))
     end

  elsif ['users','roles'].include? controller

   content_tag(:ul, ""<< 
   content_tag(:li, (link_to "usuarios",users_path ,extra_options("users",controller))) <<
   content_tag(:li, (link_to "roles", roles_path,extra_options("roles",controller))))



    elsif ['sales','quotes'].include? controller

    if admin? || store_admin? || store_supervisor?
     content_tag(:ul, ""<< 
     content_tag(:li, (link_to "boleta", "#",:id=>"boleta", :class=>"active")) <<
     content_tag(:li, (link_to "factura", "#",:id=>"factura")) <<
     content_tag(:li, (link_to "n. de cr&eacute;dito", "#",:id=>"nota_de_credito")) <<  
     content_tag(:li, (link_to "cotizacion",quotes_path,:id=>"cotizacion")) <<
     content_tag(:li, (link_to "de web",quotes_from_web_path,:id=>"cotizacion")) <<     
     content_tag(:li, (link_to "orden de salida",exit_orders_path,:id=>"orden_de_salida")))     
   else

     content_tag(:ul, ""<< 
     content_tag(:li, (link_to "boleta", "#",:id=>"boleta", :class=>"active")) <<
     content_tag(:li, (link_to "factura", "#",:id=>"factura")) <<
     content_tag(:li, (link_to "cotizacion",quotes_path,:id=>"cotizacion")) <<
     content_tag(:li, (link_to "orden de salida",exit_orders_path,:id=>"orden_de_salida")))          
     
   end
   
  elsif 'exit_orders' == controller
    
      if admin? || store_admin? || store_supervisor?
       content_tag(:ul, ""<< 
       content_tag(:li, (link_to "boleta", sales_path,:id=>"boleta")) <<
       content_tag(:li, (link_to "factura", sales_path,:id=>"factura")) <<
       content_tag(:li, (link_to "n. de cr&eacute;dito", sales_path,:id=>"nota_de_credito")) <<  
       content_tag(:li, (link_to "cotizacion",quotes_path,:id=>"cotizacion")) <<
       content_tag(:li, (link_to "de web",quotes_from_web_path,:id=>"cotizacion")) <<     
       content_tag(:li, (link_to "orden de salida",exit_orders_path,:id=>"orden_de_salida")))     
     else

       content_tag(:ul, ""<< 
       content_tag(:li, (link_to "boleta", sales_path,:id=>"boleta")) <<
       content_tag(:li, (link_to "factura", sales_path,:id=>"factura")) <<
       content_tag(:li, (link_to "cotizacion",quotes_path,:id=>"cotizacion")) <<
       content_tag(:li, (link_to "orden de salida",exit_orders_path,:id=>"orden_de_salida")))
     end

   elsif ["reports","expenses"].include? controller

     unless store?
       
       if admin? || store_admin? || store_supervisor? 
        content_tag(:ul, ""<< 
        content_tag(:li, (link_to "resumen",reports_path, extra_options("reports", controller))) <<
        content_tag(:li, (link_to "aceptaciones", acceptance_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "ingresos de inventario", input_orders_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "compras", buyings_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "devoluciones de clientes", returns_report_path,extra_options("reports", controller))) <<

        content_tag(:li, (link_to "traslados",send_orders_report_path, extra_options("reports", controller))) <<
        content_tag(:li, (link_to "ordenes salida", exit_orders_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "envios",sending_guides_report_path, extra_options("reports", controller))) <<    
        content_tag(:li, (link_to "perdidas", perdidas_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "mal estado", mal_estados_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "consumos internos", consumos_internos_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "consumos externos", consumos_externos_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "devoluciones a proveedor", devoluciones_report_path,extra_options("reports", controller))) <<        
        content_tag(:li, (link_to "cotizaciones", quotes_report_path,extra_options("reports", controller))) <<  
        content_tag(:li, (link_to "cotizaciones web", quotes_from_web_report_path,extra_options("reports", controller))) <<        
        content_tag(:li, (link_to "pedidos", quote_requests_report_path,extra_options("reports", controller))) <<        
        content_tag(:li, (link_to "ventas", orders_report_path,extra_options("reports", controller))) <<    
        content_tag(:li, (link_to "caja", expenses_path,extra_options("expenses", controller))) <<        
        content_tag(:li, (link_to "items por d&iacute;a", items_per_day_path,extra_options("reports", controller))) <<    
        content_tag(:li, (link_to "inventario", inventary_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "stock minimo", min_stock_report_path,extra_options("reports", controller))))
      else

        content_tag(:ul, ""<< 
        content_tag(:li, (link_to "resumen",reports_path, extra_options("reports", controller))) <<
        content_tag(:li, (link_to "traslados",send_orders_report_path, extra_options("reports", controller))) <<
        content_tag(:li, (link_to "aceptaciones", acceptance_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "envios",sending_guides_report_path, extra_options("reports", controller))) <<    
        content_tag(:li, (link_to "ordenes salida", exit_orders_report_path,extra_options("reports", controller))) <<
        content_tag(:li, (link_to "caja", expenses_path,extra_options("expenses", controller))))
        
      end


    else
      content_tag(:ul, ""<< 
      content_tag(:li, (link_to "resumen",reports_path, extra_options("reports", controller))) <<
      content_tag(:li, (link_to "traslados",send_orders_report_path, extra_options("reports", controller))) <<
      content_tag(:li, (link_to "envios",sending_guides_report_path, extra_options("reports", controller))) <<    
      content_tag(:li, (link_to "ingresos", input_orders_report_path,extra_options("reports", controller))) <<
      content_tag(:li, (link_to "aceptaciones", acceptance_report_path,extra_options("reports", controller))))      
    end


    elsif ['acceptance','buying_orders'].include?(controller)

      unless store?

        content_tag(:ul, ""<< 
        content_tag(:li, (link_to "proveedores", input_orders_path, extra_options("buying_orders",controller))) <<
        content_tag(:li, (link_to "compras", compras_path, extra_options("buying_orders",controller))) <<
        content_tag(:li, (link_to "inventario", inventario_path, extra_options("buying_orders",controller))) <<
        content_tag(:li, (link_to "devoluciones", devoluciones_path, extra_options("buying_orders",controller))) <<                
        content_tag(:li, (link_to "tienda", acceptance_path,extra_options("acceptance",controller) )))


      else

        content_tag(:ul, ""<< 
        content_tag(:li, (link_to "tienda", acceptance_path,extra_options("acceptance",controller) )))
  

      end

    end



  end
  
  
  def get_pending_stocks_per_store(pending,product)

    @on_almacen = 0
    @on_trigal = 0
    @on_polo = 0
    @on_carisa = 0

     pending = 0 if pending == nil 
     if product.stock_almacen.nil?
       product.stock_almacen = 0
       product.save
     end

     if product.stock_clarisa.nil?
       product.stock_clarisa = 0
       product.save
     end

     if product.stock_trigal.nil?
       product.stock_trigal = 0
       product.save
     end

     if product.stock_polo.nil?
       product.stock_polo = 0
       product.save
     end              

      if pending <= product.stock_almacen and not pending.zero?  
         @on_almacen = pending
         pending = 0
       elsif pending > product.stock_almacen                           
         @on_almacen = product.stock_almacen
         pending -= product.stock_almacen                            
       end

     if pending <= product.stock_clarisa and not pending.zero?  
        @on_carisa = pending
        pending = 0
      elsif pending > product.stock_clarisa                           
        @on_carisa = product.stock_clarisa
        pending -= product.stock_clarisa                            
      end

    if pending <= product.stock_trigal and not pending.zero?  
         @on_trigal = pending
         pending = 0
     elsif pending > product.stock_trigal                           
         @on_trigal = product.stock_trigal
         pending -= product.stock_trigal                           
     end

     if pending <= product.stock_polo and not pending.zero?  
          @on_polo = pending
          pending = 0
      elsif pending > product.stock_polo
          @on_polo = product.stock_polo
          pending -= product.stock_polo
      end



   end
  
  
end
