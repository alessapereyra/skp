ActionController::Routing::Routes.draw do |map|


  map.send_mails  '/clientes/enviar_correos/',:controller=>'catalogue', :action=>'send_client_mails'
  
  map.resources :funds
  
  map.resources :roles

  map.resources :users, :as=>'usuarios'

  map.resources :brands, :as=>'marcas'

  map.resources :sending_guides, :as=>'envios_clientes'

  map.resources :pages, :collection => {:search_product=>:get}

  map.resources :quotes, :collection => {:search_product=>:get}, :as=>'cotizaciones'

  map.resources :units

  map.resources :categories, :as=>'categorias'
  


  map.resources :orders, :controller=>"sales", :as=>"ordenes_venta"
  map.resources :exit_orders, :controller=>"exit_orders", :as=>"ordenes_salida"
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

  map.auto_complete ':controller/:action', 
                    :requirements => { :action => /auto_complete_for_\S+/ },
                    :conditions => { :method => :get }

  map.resources :products, :as=>"productos", :member => {:recalculate_stocks => :get,:recalculate_this_stock=>:get}
  map.resources :input_orders, :controller=>"buying_orders", :as=>"ingresos"
  
  # map.resources :send_orders, :as=>'ordenes_envio'dd  
  map.resources :send_orders, :controller=>"sending", :as=>"envios"
  map.resources :providers, :as=>"proveedores"
  map.resources :stores, :as=>"admin_tiendas"
  map.resources :categories, :as=>"categorias"
  map.resources :units, :as=>"unidades"
  map.resources :clients, :as=>"clientes", :member =>{:search_clients => :get}
  map.resources :order_details, :as =>"detalles_ordenes"
  map.resources :send_order_details, :as=>"detalles_orden_salida"
  map.resources :input_order_details, :as=>"detalles_orden_ingreso"
  map.resource :sending_guide_details, :as=>"detalles_guia_remision"
  map.resources :expenses, :as=>"gastos"  
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.delete_detail '/sending_guides/destroyDetail/:id', :controller=>"sending_guides",:action=>"destroyDetail"
  map.product_history '/catalogo/historial_producto/:id', :controller=>"catalogue", :action=>"historial"
  map.clients_catalogue '/catalogo/clientes', :controller=>"catalogue", :action=>"clients"
  map.providers_catalogue '/catalogo/proveedores', :controller=>"catalogue", :action=>"providers"  
 
  map.input_orders_catalogue '/ordenes_ingresos/', :controller=>"input_orders", :action=>"index"
  map.edit_input_order_catalogue '/ordenes_ingresos/:id', :controller=>"input_orders", :action=>"edit"
  map.delete_input_order_catalogue '/ordenes_ingresos/:id/delete', :controller=>'input_orders', :action=>"delete"  
  map.reopen_input_order_catalogue '/ordenes_ingresos/:id/reabrir', :controller=>"input_orders", :action=>"reopen"

  map.admin_sending_guides_catalogue '/guias_remision/', :controller=>"admin_sending_guides", :action=>"index"
  map.edit_admin_sending_guide_catalogue '/guias_remision/:id', :controller=>"admin_sending_guides", :action=>"edit"
  map.delete_admin_sending_guide_catalogue '/guias_remision/:id/delete', :controller=>'admin_sending_guides', :action=>"delete"  
  map.reopen_admin_sending_guide_catalogue '/guias_remision/:id/reabrir', :controller=>"admin_sending_guides", :action=>"reopen"
  map.return_admin_sending_guide_catalogue '/guias_remision/:id/finalizar', :controller=>"sending_guides", :action=>"return_stock"

  map.admin_exit_orders_catalogue '/admin_ordenes_salida/', :controller=>"admin_exit_orders", :action=>"index"
  map.edit_admin_exit_order_catalogue '/admin_ordenes_salida/:id', :controller=>"admin_exit_orders", :action=>"edit"
  map.delete_admin_exit_order_catalogue '/admin_ordenes_salida/:id/delete', :controller=>'admin_exit_orders', :action=>"delete"  
  map.reopen_admin_exit_order_catalogue '/admin_ordenes_salida/:id/reabrir', :controller=>"admin_exit_orders", :action=>"reopen"
  map.return_admin_exit_order_catalogue '/admin_ordenes_salida/:id/finalizar', :controller=>"exit_orders", :action=>"return_stock"

  map.compras '/compras/', :controller=>"buying_orders", :action=>"compras"
  map.inventario '/inventario/', :controller=>"buying_orders", :action=>"inventario"
  map.devoluciones '/devoluciones/', :controller=>"buying_orders", :action=>"devoluciones"  

  map.perdida '/perdida/', :controller => "sending_guides", :action => "perdida"
  map.mal_estado '/mal_estado/', :controller => "sending_guides", :action => "mal_estado"
  map.consumo_interno '/consumo_interno/', :controller => "sending_guides", :action => "consumo_interno"
  map.consumo_externo '/consumo_externo/', :controller => "sending_guides", :action => "consumo_externo"
  map.devolucion '/devolucion/', :controller => "sending_guides", :action => "devolucion"  
      
  map.quotes_catalogue '/cotizaciones/', :controller=>"quotes", :action=>"index"
  map.edit_quote_catalogue '/cotizaciones/:id/recover', :controller=>"quotes", :action=>"recover"
  map.delete_quote_catalogue '/cotizaciones/:id/delete', :controller=>'quotes', :action=>"delete"  
  map.reopen_quote_catalogue '/cotizaciones/:id/reabrir', :controller=>"quotes", :action=>"reopen"
  map.send_quote 'cotizaciones/:id/enviar', :controller=>"quotes", :action=>"send_quote"
  map.download_quote 'web/cotizaciones/:id/descargar',:controller=>"quote_excel", :action=>"xls"
  map.download_pdf_quote 'web/cotizaciones/:id/descargar_pdf',:controller=>"quote_excel", :action=>"pdf",:format=>"pdf"
  map.update_quote 'web/cotizaciones/:id/actualizar', :controller=>"quotes",:action=>"modify_quote"
  map.web_quote 'web/cotizaciones/:contact_name/', :controller=>"pages", :action=>"cotizaciones"

  map.send_orders_catalogue '/ordenes_envio/', :controller=>"send_orders", :action=>"index"
  map.reopen_send_order '/ordenes_envio/:id/reabrir', :controller=>"send_orders", :action=>"recover"
  map.edit_send_order_catalogue '/ordenes_envios/:id', :controller=>"send_orders", :action=>"edit"
  map.delete_send_order_catalogue '/ordenes_envios/:id/delete', :controller=>'send_orders', :action=>"delete"
  map.orders_catalogue '/ordenes_ventas/', :controller=>'orders', :action=>"index"
  map.edit_order_catalogue '/ordenes_ventas/:id', :controller=>'orders', :action=>"edit"
  map.delete_order_catalogue '/ordenes_ventas/:id/delete', :controller=>'orders', :action=>"delete"
  map.change_store '/options/change_store', :controller=>'application', :action=>'change_store'
  map.seach_catalogue '/catalogo/#:value', :controller=>"catalogue", :action=>"index"
  map.login '/login', :controller=>'login',:action=>'login'
  map.logout '/logout', :controller=>'login',:action=>'logout'
  map.no_access '/denegado', :controller=>'login', :action=>'disallow'
  map.sales "/ventas", :controller=>"sales", :action=>"index"
  map.home "/", :controller=>"pages", :action=>"catalogo"  
  map.order "/ventas", :controller=>"sales", :action=>"index"
  map.reports "/reportes", :controller=>"reports",:action=>"index"
  map.sending "/envios", :controller=>"sending",:action=>"index"
  map.acceptance "/recepcion", :controller=>"acceptance", :action=>"index"
  map.check_order "/recepcion/:id", :controller=>"acceptance", :action=>"send_order"    

  map.input_orders_report "/reportes/inventarios", :controller=>"reports",:action=>"input_orders"    
  map.buyings_report "/reportes/compras", :controller=>"reports",:action=>"buyings"  
  map.returns_report "/reportes/devoluciones_clientes", :controller=>"reports",:action=>"returns"  


  map.perdidas_report "/reportes/perdidas", :controller=>"reports",:action=>"perdidas"    
  map.mal_estados_report "/reportes/mal_estados", :controller=>"reports",:action=>"mal_estados"  
  map.consumos_internos_report "/reportes/consumos_internos", :controller=>"reports",:action=>"consumos_internos"  
  map.consumos_externos_report "/reportes/consumos_externos", :controller=>"reports",:action=>"consumos_externos"
  map.devoluciones_report "/reportes/devoluciones_proveedor", :controller=>"reports",:action=>"devoluciones"  
    
  map.input_order_report "/reportes/ingresos/:id", :controller=>"reports",:action=>"input_order"    

  map.items_per_day "/reportes/items_por_dia/", :controller=>"reports",:action=>"items_per_day"  
  map.quotes_from_web "/reportes/cotizaciones_web/", :controller=>"quotes",:action=>"from_web"  
  
  map.quotes_from_web_report "/reportes/cotizaciones/web/", :controller=>"reports",:action=>"web_quotes"  
  map.quote_from_web "/reportes/cotizaciones_web/:id", :controller=>"quotes",:action=>"review"  
  map.quotes_report "/reportes/cotizaciones", :controller=>"reports",:action=>"quotes"     

  map.exit_orders_report "/reportes/ordenes_salidas/", :controller=>"reports", :action=>"exit_orders"
  map.exit_order_report "/reportes/ordenes_salidas/:id", :controller=>"reports", :action=>"exit_order"

  
  map.exit_orders "/ventas/ordenes_salida/", :controller=>"exit_orders", :action=>"index"
  
  map.quote_report "/reportes/cotizaciones/:id", :controller=>"reports",:action=>"quote"    

  map.min_stock_report "/reportes/stock_minimo/", :controller=>"reports",:action=>"min_stock"    

  map.inventary_report "/reportes/inventario/", :controller=>"reports",:action=>"inventary"    

  map.massive_input_order_edit "/ordenes_ingreso/edicion_masiva", :controller=>"input_orders", :action=>"massive_edit"

  map.quote_requests_report "/reportes/pedidos/", :controller=>"reports",:action=>"quote_requests"
  map.quote_request_report "/reportes/pedidos/:id", :controller=>"reports",:action=>"quote_request"

  map.delivered_quotes_report "/reportes/pedidos_enviados/", :controller=>"reports",:action=>"delivered_quotes"
  map.delivered_quote_report "/reportes/pedidos_envidados/:id", :controller=>"reports",:action=>"delivered_quote"

  map.send_orders_report "/reportes/envios", :controller=>"reports",:action=>"send_orders"   
  map.send_order_report "/reportes/envios/:id", :controller=>"reports",:action=>"send_order"  
  map.sending_guides_report "/reportes/guia_envios", :controller=>"reports",:action=>"sending_guides"   
  map.sending_guide_report "/reportes/guia_envios/:id", :controller=>"reports",:action=>"sending_guide"  
  map.orders_report "/reportes/ventas", :controller=>"reports",:action=>"orders"   
  map.order_report "/reportes/ventas/:id", :controller=>"reports",:action=>"order"     
  map.acceptances_report "/reportes/recepciones", :controller=>"reports",:action=>"acceptances"     
  map.acceptance_report "/reportes/recepciones/:id", :controller=>"reports",:action=>"acceptance"     
  map.order_from_guide "/ordenes_ventas/guia_remision/:id", :controller=>"sending_guides", :action=>"create_order"
  map.recreate_barcode "/reportes/productos/:id/etiquetas/recrear", :controller=>"inventory", :action=>"barcode"
  map.dashboard "/reportes", :controller=>"reports",:action=>"index"  
  map.prices_reports "/reportes/productos/:id", :controller=>"reports",:action=>"product_prices"
  map.product_prices "productos/:id/precios/", :controller=>"sales", :action=>"all_product_prices"
  map.catalogue "/catalogue", :controller=>"catalogue", :action=>"index", :as=>"catalogo"
  map.inventory "/inventory", :controller=>"inventory", :action=>"index", :as=>"inventario"
  map.inventory_client "/ventas/clientes", :controller=>"clients", :action=>"index", :as=>"inventario"  
  map.tags "/inventory/tags", :controller=>"inventory", :action=>"tags", :as=>"inventario/etiquetas"  
  map.print_tag "/reportes/productos/:id/etiquetas", :controller=>"inventory", :action=>"print"
  map.print_input_order_tags "/reportes/ingresos/:id/etiquetas", :controller=>"inventory", :action=>"print_input_order"  
  map.print_send_order_tags "/reportes/envios/:id/etiquetas", :controller=>"inventory", :action=>"print_send_order"    
  map.home "/web/", :controller=>"pages", :action=>"catalogo"
  map.web_catalogue '/web/catalogo', :controller=>'pages', :action=>'catalogo'
  map.product_catalogue 'web/catalogo/:id',:controller=>'pages',:action=>'detalle'
  map.web_add_product 'web/catalogo/agregar/:id', :controller=>'pages', :action=>'agregar_producto'
  map.web "/web/:action/:id", :controller=>"pages"
  map.print "/print/:action/:id",:controller=>"print"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
