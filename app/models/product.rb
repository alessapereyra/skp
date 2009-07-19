# == Schema Information
# Schema version: 20090320214122
#
# Table name: products
#
#  id                        :integer(4)      not null, primary key
#  additional_code           :string(255)
#  name                      :string(255)
#  description               :string(255)
#  stock                     :decimal(10, 2)
#  created_at                :datetime
#  updated_at                :datetime
#  image                     :string(255)
#  code                      :string(255)
#  picture                   :string(255)
#  picture_filesize          :integer(8)
#  visible                   :boolean(1)
#  barcode_filename          :string(255)
#  warehouse_place           :string(255)
#  buying_price              :decimal(10, 2)
#  category_id               :integer(4)
#  subcategory_id            :integer(4)
#  status                    :string(255)
#  brand_id                  :integer(4)
#  stock_trigal              :decimal(10, 2)
#  stock_polo                :decimal(10, 2)
#  age                       :string(255)
#  height                    :decimal(10, 2)
#  width                     :decimal(10, 2)
#  weight                    :decimal(10, 2)
#  length                    :decimal(10, 2)
#  sex                       :string(255)
#  age_from                  :integer(4)
#  age_to                    :integer(4)
#  stock_almacen             :decimal(10, 2)
#  stock_clarisa             :decimal(10, 2)
#  print_description         :boolean(1)
#  stock_trigal_compromised  :integer(4)      default(0)
#  stock_polo_compromised    :integer(4)      default(0)
#  stock_almacen_compromised :integer(4)      default(0)
#  stock_carisa_compromised  :integer(4)      default(0)
#  corporative_price         :decimal(10, 2)
#  delta                     :boolean(1)
#



#require 'acts_as_ferret'
require 'barby'
require 'barby/outputter/rmagick_outputter' 

  
class Product < ActiveRecord::Base

  #acts_as_ferret :fields=>[:name, :description, :code, :category_name, :subcategory_name,:brand_name,:product_provider_codes]
  image_column :picture,:root_path => File.join(RAILS_ROOT, 'public/product_photos'),:versions => { :thumb => '100x100', :large => '800x800'}
  
  has_many :order_details
  has_many :orders, :through => :order_details
  
  has_many :quote_details
  has_many :quotes, :through => :quote_details, :order=>"created_at ASC"
  has_many :prices

  has_many :input_order_details
  has_many :input_orders, :through => :input_order_details
  
  has_many :send_order_details
  has_many :send_orders, :through=>:send_order_details
  
  has_many :sending_guide_details
  has_many :sending_guides, :through=>:sending_guide_details

  has_many :exit_order_details
  has_many :exit_orders, :through => :exit_order_details

  has_one :category
  belongs_to :unit
  belongs_to :category
  belongs_to :subcategory, :class_name=>"Category"
  
  belongs_to :brand
  


  has_many :input_order_details, :order=>"created_at DESC"
  has_many :input_orders, :through=>:input_order_details
  has_many :last_input_orders, :class_name => "InputOrderDetail", :order=>"order_date DESC", :limit=>5
  #has_many :stores, :through => :input_order_details  

  
  
  validates_presence_of :name, :on => :create, :message => " debe tener un valor"
  validates_presence_of :stock, :on => :create, :message => " debe tener un valor"
  validates_numericality_of :stock, :on => :create, :message => " no es un número"
  validates_uniqueness_of :code, :message => "debe ser único"
  
  
  
  #acts_as_ferret :fields=>[:name, :description, :code, :category_name, :subcategory_name,:brand_name,:product_provider_codes]
  
  
  define_index do
      # fields
      indexes :name, :sortable => true
      indexes description
      indexes visible
      indexes code, :sortable => true
      indexes category.name, :as => :category_name
      indexes subcategory.name, :as => :subcategory_name
      indexes brand.name, :as => :brand_name
      indexes input_order_details.additional_code, :as => :product_provider_codes
      indexes :status

      # attributes
      has corporative_price, age_from, age_to, stock
      has :updated_at, :sortable => true
      has :category_id
      set_property :delta => true
      set_property :enable_star => true
      set_property :min_infix_len => 3
    end
  

  def is_stationary? 
    
    return false if self.category.blank? 
      
    self.category.name == "UTILES"
    
  end
  
  def is_book?
    return false if self.category.blank? 
      
    self.category.name == "LIBROS"

  end
  

  def available_stock_trigal
    self.stock_trigal = 0 if self.stock_trigal.nil?
    self.stock_trigal - self.stock_trigal_compromised
  end

  def available_stock_polo
    self.stock_polo = 0 if self.stock_polo.nil?
    self.stock_polo - self.stock_polo_compromised
  end

  def available_stock_almacen
    self.stock_almacen = 0 if self.stock_almacen.nil?
    self.stock_almacen - self.stock_almacen_compromised
  end

  def available_stock_carisa
    self.stock_clarisa = 0 if self.stock_clarisa.nil?    
    self.stock_clarisa - self.stock_carisa_compromised
  end

  def update_available_stock(store_id,quantity)

    #  stock_trigal_compromised  :integer(11)     default(0)
    #  stock_polo_compromised    :integer(11)     default(0)
    #  stock_almacen_compromised :integer(11)     default(0)
    #  stock_carisa_compromised  :integer(11)     default(0)


    case store_id
      when 1
        self.stock_trigal_compromised += quantity
      when 2
        self.stock_polo_compromised += quantity        
      when 3
        self.stock_almacen_compromised += quantity        
      when 5
        self.stock_carisa_compromised += quantity        
    end
    
    self.save
    
  end

  def edad_desde
    self.age_from
  end
  
  def edad_hasta
    self.age_to
  end
  
  def category_name
    return self.category.nil? ? "" : self.category.name
  end

  def subcategory_name
    return self.subcategory.nil? ? "" : self.subcategory.name
  end
  
  def brand_name
    return self.brand.nil? ? "" : self.brand.name
  end

  def providers
    
    providers = []

    self.input_orders.each do |io|
      
      unless providers.include? io.provider 
        providers << io.provider
      end
      
    end
    
    return providers
    
  end
  
  def providers_ids

    providers = []

    self.input_orders.each do |io|
      
      unless providers.include? io.provider_id
        providers << io.provider_id
      end
      
    end
    
    return providers
    
    
  end
  
  def active_input_orders
    
    input_order_details = []
    offset = 0
    total = 0

    unless self.input_order_details.nil? or self.input_order_details.empty?
    
      2.times do
        iod = self.input_order_details.find(:all,:limit=>1,:offset=>offset, :conditions=>"prices_count = 5").first
          total += iod.quantity unless iod.blank? or iod.quantity.nil? 
          input_order_details << iod unless iod.blank?
          offset += 1
      end
    
    
    end
  
    return input_order_details
    
  end
  
  def provider_codes
    provider_codes = []
    self.input_order_details.each {|iod| provider_codes << iod.additional_code unless provider_codes.include? iod.additional_code     }
    return provider_codes
  #  InputOrderDetail.find_by_sql("select additional_code from input_order_details where product_id=#{self.id}")
    
  end
  
  def product_provider_codes
    return self.provider_codes.join(" ")
  end
  
  #Rehacer este método guardando el average_price en la BD y obtenerlo de ahí
  def average_price
    total = 0.00
    self.prices.map {|price| total += price.amount }
    prices.count.zero? ? 0.00 : (total /= self.prices.count).round(2)
  end
  
  def store_stock(store)
    if store == 1
      self.stock_trigal || 0.0
    elsif store == 2
      self.stock_polo || 0.0   
    elsif store == 3
      self.stock_almacen || 0.0
    elsif store == 5  #4 es todas las tiendas
      self.stock_clarisa || 0.0
    end
  end
   
  def total_and_pending_amounts
    total = 0
    pending = 0
    self.quotes.requested.each do |q|
      
      q.quote_details.find_all_by_product_id_and_additional(self.id,false).each do |quote_detail|
        
        total += quote_detail.quantity
        pending += quote_detail.pending
        
      end #quote_detail each
      
    end #quotes each
    
    return total,pending
    
   end  #pending_amount
   
   
   def get_pending_stocks_per_store
     #  stock_trigal_compromised  :integer(11)     default(0)
     #  stock_polo_compromised    :integer(11)     default(0)
     #  stock_almacen_compromised :integer(11)     default(0)
     #  stock_carisa_compromised  :integer(11)     default(0)
     
     total=pending=on_almacen=on_carisa=on_trigal=on_polo = 0
     quote_details = []
     self.quotes.requested.each do |q|
       
       q.quote_details.find_all_by_product_id_and_additional(self.id,false).each do |quote_detail|

            unless quote_details.include? quote_detail 
              on_almacen += quote_detail.stock_almacen_compromised
              on_carisa += quote_detail.stock_carisa_compromised
              on_trigal += quote_detail.stock_trigal_compromised
              on_polo += quote_detail.stock_polo_compromised                                    
              total += quote_detail.quantity
              pending += quote_detail.pending
              quote_details << quote_detail
            end
          end #quote_detail each
          
      end

        return total,pending,on_almacen,on_carisa,on_trigal,on_polo
     
   end
   
   
   
   def get_pending_stocks_per_store_by_quote(quote_id)
     #  stock_trigal_compromised  :integer(11)     default(0)
     #  stock_polo_compromised    :integer(11)     default(0)
     #  stock_almacen_compromised :integer(11)     default(0)
     #  stock_carisa_compromised  :integer(11)     default(0)
     
     total = pending = on_almacen = on_carisa = on_trigal = on_polo = 0
     quote_details = []

        self.quote_details.find_all_by_product_id_and_quote_id_and_additional(self.id,quote_id,false).each do |quote_detail|

          unless quote_details.include? quote_detail 
          
            on_almacen += quote_detail.stock_almacen_compromised
            on_carisa += quote_detail.stock_carisa_compromised
            on_trigal += quote_detail.stock_trigal_compromised
            on_polo += quote_detail.stock_polo_compromised                                    
            total += quote_detail.quantity
            pending += quote_detail.pending
            quote_details << quote_detail
          
          end
          
            
          end #quote_detail each

        return total,pending,on_almacen,on_carisa,on_trigal,on_polo
     
   end
   
  
   def total_and_pending_amounts_by_quote(quote_id)
     total = 0
     pending = 0
     self.quote_details.find_all_by_product_id_and_quote_id_and_additional(self.id,quote_id,false).each do |quote_detail|

         total += quote_detail.quantity
         pending += quote_detail.pending

       end #quote_detail each

     return total,pending

    end  #pending_amount
  
  
  def unload_stock
    
    self.quotes.requested.each do |q|
      
      q.quote_details.find_all_by_product_id_and_additional(self.id,false).each do |quote_detail|
        
        quote_detail.unload_stock
        
      end
      
    end
    
  end
  
  def unload_if_pending
    
    self.quotes.requested.each do |q|
      
      q.quote_details.find_all_by_product_id(self.id, :conditions=>"pending > 0").each do |quote_detail|  # encontramos todos los detalles de pedidos que todavía tengan pendientes 
        
        quote_detail.continue_unload_stock   #que continue el descargo suficiente
        
        
      end
      
    end
    
  end
   
  def create_barcode!
  
    barcode = Barby::Code128B.new(self.code)

    barcode_filename = "barcodes/#{self.id}.png"
    barcode_filename_root = RAILS_ROOT + "/public/" + barcode_filename

    File.open(barcode_filename_root, 'w') do |f|
      f.write barcode.to_png
      self.barcode_filename = barcode_filename
      self.save!
    end

  end 
  
  
  def recalculate_stocks_of_store(store_id)
    
    
     #Stocks por tienda
      stock = 0

      store = Store.find(store_id)
      iod = [] #InputOrderDetails
      od = [] #OrderDetails
      sgd = [] #SendingGuideDetails
      asod = [] #Accepted SendOrderDetails
      psod = [] #Pending SendOrderDetails
      sod = []
      eod = []
      
      
      #Obtenemos los ingresos, ventas, traslados de la tienda
      store.input_orders.accepted.each {|io|  temp = io.input_order_details.find_all_by_product_id(self.id); 
        temp.each do |t| iod << t unless t.nil? end  }
      store.orders.accepted.each {|io|  temp = io.order_details.find_all_by_product_id(self.id); 
        temp.each do |t| od << t unless t.nil?  end }
      store.sending_guides.accepted.each {|io|  temp = io.sending_guide_details.find_all_by_product_id(self.id); 
        temp.each do |t| sgd << t unless t.nil? end  }

     store.send_orders.accepted.each {|io|  temp = io.details_for_product(self.id); asod << temp unless temp.nil?   }
    # store.send_orders.pending.each {|io|  temp = io.details_for_product(self.id); psod << temp unless temp.nil?   }   
      #store.owned_send_orders.accepted.each {|io|  temp = io.send_order_details.find_by_product_id(self.id); asod << temp unless temp.nil? }
      #store.owned_send_orders.pending.each {|io|  temp = io.send_order_details.find_by_product_id(self.id); psod << temp unless temp.nil? }
      
      store.owned_send_orders.pending.each {|io| temp = io.send_order_details.find(:all,:conditions=>{:product_id=>self.id}); sod << temp unless temp.nil? or temp.empty?}

      store.owned_send_orders.accepted.each {|io| temp = io.send_order_details.find(:all,:conditions=>{:product_id=>self.id}); sod << temp unless temp.nil? or temp.empty?}

      store.exit_orders.accepted.each {|io| temp = io.exit_order_details.find(:all,:conditions=>{:product_id=>self.id});  eod << temp unless temp.nil? or temp.empty? }
   
      iod.map {|i|  stock += i.quantity }
      od.map {|i|  stock -= i.quantity }
      sgd.map {|i|  stock -= i.quantity }            
      eod.map {|i|  i.each do |io| stock -= io.quantity end }            
      sod.map {|i|  i.each do |io| stock -= io.quantity end }

      asod.map {|i| i.each do |io| stock += io.quantity end }
 #     psod.map {|i|  stock -= i.quantity }



      stock
    
  end
  
  
  def process_recalculation
    
    

        #  stock_trigal_compromised  :integer(11)     default(0)
        #  stock_polo_compromised    :integer(11)     default(0)
        #  stock_almacen_compromised :integer(11)     default(0)
        #  stock_carisa_compromised  :integer(11)     default(0)

        stock = 0    

        iod = [] #InputOrderDetails
        od = [] #OrderDetails
        sgd = [] #SendingGuideDetails
        psod = [] #Pending SendOrderDetail
        rsg = []
        eod = []
        #  qd = []

        #Stocks totales
        self.stock = 0
        self.stock_trigal = 0
        self.stock_polo = 0
        self.stock_almacen = 0
        self.stock_clarisa = 0
        
        #p.input_orders.accepted.inject {|sum,io| sum + io.input_order_details.inject{|st,iod| st + iod.quantity }}
        
        self.input_orders.accepted.each do |io| 
          temp = io.input_order_details.find_all_by_product_id(self.id); 
          temp.each do |t| iod << t unless (t.nil? or iod.include? t) end
          end

          self.orders.accepted.each do |o| 
            temp = o.order_details.find_all_by_product_id(self.id); 
            temp.each do |t| od << t unless t.nil? or od.include? t end
            end

            self.sending_guides.accepted.each do |sg| 
              temp = sg.sending_guide_details.find_all_by_product_id(self.id); 
              temp.each do |t| sgd << t unless t.nil? or sgd.include? t end
              end
=begin
              self.sending_guides.returned.each do |sgr|
                temp = sgr.sending_guide_details.find_all_by_product_id(self.id);
                temp.each do |t| rsg << t unless t.nil? or rsg.include? t end
                end
=end

                self.send_orders.pending.each do |so| 

                  temp = so.send_order_details.find_all_by_product_id(self.id);
                  temp.each do |t| psod << t unless t.nil? or psod.include? t end

                  end
                  
                  self.exit_orders.accepted.each do |eo|
                    
                    temp = eo.exit_order_details.find_all_by_product_id(self.id);
                    temp.each do |t| eod << t unless t.nil? or eod.include? t end
                    
                    
                  end

=begin
                  self.quotes.requested.each do |q|

                    temp = q.quote_details.find_all_by_product_id(self.id);
                    temp.each do |t| qd << t unless t.nil? or qd.include? t end

                    end
=end

                    iod.map {|i|  stock += i.quantity }
                    
                    RAILS_DEFAULT_LOGGER.error("\n Stock #{ stock }  \n")                 
                    
                    
                    od.map {|i|  stock -= i.quantity }

                    RAILS_DEFAULT_LOGGER.error("\n Stock Entrada #{ stock }  \n")                 

                    sgd.map {|i|  stock -= i.quantity }   
                    psod.map {|i| stock -= i.quantity }  
                    eod.map {|i| stock -= i.quantity }                      
                    #     qd.map {|i| stock -= i.quantity - i.pending }
                    #rsg.map {|i| stock += i.quantity }      

                    self.stock += stock
=begin
                    self.input_order_details.map { | iod | self.stock += iod.quantity; } #3
                    self.order_details.map {|o| self.stock -= o.quantity;}
                    self.sending_guide_details.map {|o| self.stock -= o.quantity;}        
=end

                    #  self.send_orders.accepted.each do |so| so.details_for_product(self.id).map {|o| self.stock += o.quantity;} end 

                    #self.send_orders.pending.each do |so| so.details_for_product(self.id).map {|o| self.stock -= o.quantity;} end

                    self.save

                    self.stock_trigal = recalculate_stocks_of_store(1)
                    self.stock_polo = recalculate_stocks_of_store(2)
                    self.stock_almacen = recalculate_stocks_of_store(3)
                    self.stock_clarisa = recalculate_stocks_of_store(5)
                    self.save

                    RAILS_DEFAULT_LOGGER.error("\n #{ self.stock }  \n")  
                    RAILS_DEFAULT_LOGGER.error("\n #{ self.stock_trigal }  \n")  
                    RAILS_DEFAULT_LOGGER.error("\n #{ self.stock_polo }  \n")  
                    RAILS_DEFAULT_LOGGER.error("\n #{ self.stock_clarisa }  \n")  
                    RAILS_DEFAULT_LOGGER.error("\n #{ self.stock_almacen }  \n")                  

    
  end
  
  def recalculate_all_stocks
    
    
    
    
    
  end


  def recalculate_stocks
    
    
    Product.transaction do 
    
      setup_compromised_stock
      process_recalculation
      
      
      # requests
      temp = []
      qd = []
      stock = stock_from_trigal = stock_from_polo = stock_from_almacen = stock_from_carisa = 0
      stock_trigal_compromised = stock_polo_compromised = stock_almacen_compromised = stock_carisa_compromised = 0
       self.quotes.requested.each do |q| 
          temp = q.quote_details.find_all_by_product_id(self.id, :conditions=>"additional is false or additional is null"); 
          temp.each do |t| qd << t unless t.nil? or qd.include? t end
      end
      
      qd.map do |i| 
        
        i.quantity = 0 if i.quantity.blank?
        i.stock_from_trigal = 0 if i.stock_from_trigal.blank?
        i.stock_from_polo = 0 if i.stock_from_polo.blank?
        i.stock_from_almacen = 0 if i.stock_from_almacen.blank?
        i.stock_from_carisa = 0 if i.stock_from_carisa.blank?
        
        i.stock_trigal_compromised = 0 if i.stock_from_trigal.blank?
        i.stock_polo_compromised = 0 if i.stock_from_polo.blank?
        i.stock_almacen_compromised = 0 if i.stock_from_almacen.blank?
        i.stock_carisa_compromised = 0 if i.stock_from_carisa.blank?
        
        stock_trigal_compromised += i.stock_trigal_compromised
        stock_polo_compromised += i.stock_polo_compromised
        stock_almacen_compromised += i.stock_almacen_compromised
        stock_carisa_compromised += i.stock_carisa_compromised            
        
         stock += (i.stock_from_trigal + i.stock_from_polo + i.stock_from_carisa + i.stock_from_almacen)
         stock_from_trigal += i.stock_from_trigal 
         stock_from_polo += i.stock_from_polo
         stock_from_almacen += i.stock_from_almacen
         stock_from_carisa += i.stock_from_carisa
      end
      
      self.stock -= stock
      self.stock_trigal -= stock_from_trigal
      self.stock_polo -= stock_from_polo
      self.stock_almacen -= stock_from_almacen
      self.stock_clarisa -= stock_from_carisa
      self.stock_carisa_compromised = stock_carisa_compromised
      self.stock_trigal_compromised = stock_trigal_compromised
      self.stock_polo_compromised = stock_polo_compromised
      self.stock_almacen_compromised = stock_almacen_compromised
      self.save

    end
    
  end
  
  def continue_recalculation
    
    Product.transaction do 
    
     # setup_compromised_stock
      process_recalculation

      self.quotes.requested.each do |q|       
        q.quote_details.find_all_by_product_id(self.id).each do |quote_detail|                  	
          quote_detail.unload_stock
          quote_detail.save
        end
        q.save
      end
      self.save
    end    
    
    
  end
  
  def setup_compromised_stock
          self.stock_trigal_compromised = 0
          self.stock_polo_compromised = 0
          self.stock_almacen_compromised = 0
          self.stock_carisa_compromised = 0
    
  end
  
  
  
   def recalculate_stocks_without_requests


      Product.transaction do 
        setup_compromised_stock
        process_recalculation   

      end #transaction

    end
  
   
  def current_prices(admin,store)
    latest_prices = []
    
    if store == 1
      latest_prices << self.prices.find_by_description("Precio Tienda 1",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")
    else
      latest_prices << self.prices.find_by_description("Precio Tienda 2",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")
    end

    #   latest_prices << self.prices.find_by_description("Precio base",:limit=>1,:order=>"updated_at DESC")
    if admin
       #latest_prices << self.prices.find_by_description("Precio mayorista",:conditions=>"amount is not null",:limit=>1,:order=>"updated_at DESC") 
       latest_prices << self.prices.find_by_description("Precio mayorista",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC") 
    end
     #  latest_prices << self.prices.find_by_description("Precio en caja",:limit=>1,:order=>"updated_at DESC")
     
     return latest_prices[0].nil? ? [Price.new(:amount=>"0")]  : latest_prices

  end 
  
  def all_current_prices
      # acà hay un error de data:
      # mayorista es corporativo
      # en caja es mayorista
  latest_prices = []
  latest_prices << self.prices.find_by_description("Precio base",:conditions=>"amount is not null and amount != 0", :limit=>1,:order=>"created_at DESC")
   latest_prices << self.prices.find_by_description("Precio mayorista",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")
   latest_prices << self.prices.find_by_description("Precio en caja",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")
   latest_prices << self.prices.find_by_description("Precio Tienda 1",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")
   latest_prices << self.prices.find_by_description("Precio Tienda 2",:conditions=>"amount is not null and amount != 0",:limit=>1,:order=>"created_at DESC")    
   
  end
  
  def corporative_price2
    # el objeto segundo price asociado es el precio corporativo 
    price = self.all_current_prices[1]
    
    if price.nil? then 0.00 else price.amount end
      
  end
  
  def precio_corporativo
    self.corporative_price.to_i.to_s
  end
  
  def cost_price
       price = self.input_order_details.find(:all,:limit=>1,:order=>"created_at DESC").first 
       return 0.00 if price.nil?
       return price.cost.nil? ? 0.00 : price.cost
  end
  
   
  def update_stock (quantity)

    Product.transaction do 
    RAILS_DEFAULT_LOGGER.error("\n Actualizando Stock de Producto #{self.id} - #{self.code }")  
    RAILS_DEFAULT_LOGGER.error("Stock anterior: #{self.stock} Stock Cambiante: #{quantity}")      
    return if quantity.nil?
    self.stock += quantity  
    self.save! unless self.stock < 0
    RAILS_DEFAULT_LOGGER.error("Stock Final: #{self.stock} \n ")      
    
    end #transaction
  
  end
  
  def update_store_stock (quantity, store)
   
    Product.transaction do 
      return if quantity.nil?

      if store == 1
        self.stock_trigal.nil? ?  self.stock_trigal = quantity : self.stock_trigal += quantity 
        self.save! unless self.stock_trigal < 0
      elsif store == 2
        self.stock_polo.nil? ? self.stock_polo = quantity : self.stock_polo += quantity 
        self.save! unless self.stock_polo < 0
      elsif store == 3
        self.stock_almacen.nil? ? self.stock_almacen = quantity : self.stock_almacen += quantity 
        self.save! unless self.stock_almacen < 0
      elsif store == 5  # el ID 4 es de todas las tiendas
        self.stock_clarisa.nil? ? self.stock_clarisa = quantity : self.stock_clarisa += quantity 
        self.save! unless self.stock_clarisa < 0      
      end

    end #transaction

  end
  
  def store_price(store)

=begin    
      if store.nil?
        store = Options.GetCurrentStore
      end
=end
      if store == 1
        result = self.prices.find_by_description("Precio Tienda 1", :conditions=>"amount is not null and amount != 0", :limit=>1, :order=>"created_at DESC")
        result.nil? ? 0.00 : result.amount
      else
        result = self.prices.find_by_description("Precio Tienda 2",:conditions=>"amount is not null and amount != 0", :limit=>1, :order=>"created_at DESC")
        result.nil? ? 0.00 : result.amount
      end
      

    
  end
  
  
  def split_age
    if age == "de 0 a 12 meses"
      self.age_from = 0
      self.age_to = 1
    elsif age == "de 1 a 3 años"
      self.age_from = 1
      self.age_to = 3
    elsif age == "de 4 a 6 años"
      self.age_from = 4
      self.age_to = 6
    elsif age == "de 7 a 8 años"
      self.age_from = 7
      self.age_to = 8
    elsif age == "más de 9 años"
      self.age_from = 9
      self.age_to = 18
    else
      self.age_from, self.age_to = self.age.split("-") unless self.age.nil?
      
    end
    

    
    self.save!
    
  end
   
  def self.last_code
        product = Product.find(:all,:conditions=>"status = 'pendiente' or status = 'terminada'",:order=>"id DESC").first
        
        
        if product.nil?
          "K00000"
        else
          product.code
        end
  end   
   
   
   
   
  def validate
   if !stock.nil?
    if stock < 0
      errors.add_to_base("El stock no puede ser negativo")
    end
      
  end
  
  
  def is_new_price?(price)
     result = false
     self.prices.map {|p| p.amount == price ? result |= false : result |= true  }
     return result
   end
   
  

end
  
end