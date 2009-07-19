# == Schema Information
# Schema version: 20090220010446
#
# Table name: quote_details
#
#  id                        :integer(4)      not null, primary key
#  quote_id                  :integer(4)
#  product_id                :integer(4)
#  quantity                  :integer(4)
#  product_detail            :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  from                      :integer(4)
#  to                        :integer(4)
#  age_from                  :integer(4)
#  age_to                    :integer(4)
#  price                     :decimal(10, 2)
#  version                   :integer(4)
#  from_web                  :boolean(1)
#  additional                :boolean(1)
#  sex                       :string(255)
#  pending                   :integer(4)
#  stock_from_almacen        :integer(4)
#  stock_from_carisa         :integer(4)
#  stock_from_trigal         :integer(4)
#  stock_from_polo           :integer(4)
#  unavailable               :boolean(1)
#  stock_trigal_compromised  :integer(4)      default(0)
#  stock_polo_compromised    :integer(4)      default(0)
#  stock_almacen_compromised :integer(4)      default(0)
#  stock_carisa_compromised  :integer(4)      default(0)
#  pack_number               :integer(4)
#  months                    :boolean(1)
#

class QuoteDetail < ActiveRecord::Base
  
  belongs_to :quote,:counter_cache => true
  belongs_to :product
  
  validates_numericality_of :quantity, :allow_nil=>true
  validates_numericality_of :price, :allow_nil=>true
  
  validates_presence_of :product_id

  validates_associated :product
  validates_associated :quote
  
  acts_as_versioned
  
  def version_condition_met? 
    self.from_web || self.from_web.blank?
  end
  
  named_scope :final, :conditions=>"additional is false or additional is null"
  named_scope :additional, :conditions=>{:additional => true} 
  
  def needed
    amount = self.quantity - self.product.stock
    if amount >= 0
      amount
    else
      0
    end
    
  end
  
  def subtotal
    unless quantity.nil? or price.nil?
      price*quantity*1.00
    else
      0.0
    end
  end
  
  def stock_from_store(store_id)
    
    case store_id
      when 1 # trigal
         self.stock_from_trigal.nil? ? 0 : self.stock_from_trigal
      when 2 # polo
         self.stock_from_polo.nil? ? 0 : self.stock_from_polo
      when 3 #almacen
         self.stock_from_almacen.nil? ? 0 : self.stock_from_almacen
      when 5 #carisa
         self.stock_from_carisa.nil? ? 0 : self.stock_from_carisa
      end
    
  end  
  
  def update_compromise_from_store(quantity,store_id)
    #  stock_trigal_compromised  :integer(11)     default(0)
    #  stock_polo_compromised    :integer(11)     default(0)
    #  stock_almacen_compromised :integer(11)     default(0)
    #  stock_carisa_compromised  :integer(11)     default(0)
    
    case store_id
      when 1 # trigal
         self.stock_trigal_compromised = quantity
      when 2 # polo
         self.stock_polo_compromised = quantity        
      when 3 #almacen
         self.stock_almacen_compromised = quantity        
      when 5 #carisa
         self.stock_carisa_compromised = quantity      
      end
    
  end  
  
  def update_from_store(quantity,store_id)
    
    case store_id
      when 1 # trigal
         self.stock_from_trigal = quantity
      when 2 # polo
         self.stock_from_polo = quantity        
      when 3 #almacen
         self.stock_from_almacen = quantity        
      when 5 #carisa
         self.stock_from_carisa = quantity      
      end
    
  end
  
  def check_remaining_stores(store_id)
    product = self.product.reload
    case store_id
      
      when 1
        compromise_remaining_stock(product.available_stock_almacen,3)
        compromise_remaining_stock(product.available_stock_carisa,5)
        compromise_remaining_stock(product.available_stock_polo,2)     
      when 2
        compromise_remaining_stock(product.available_stock_almacen,3) 
        compromise_remaining_stock(product.available_stock_carisa,5)      
        compromise_remaining_stock(product.available_stock_trigal,1) 
      when 3
        compromise_remaining_stock(product.available_stock_carisa,5)
        compromise_remaining_stock(product.available_stock_trigal,1) 
        compromise_remaining_stock(product.available_stock_polo,2)     
      when 5
        compromise_remaining_stock(product.available_stock_almacen,3)             
        compromise_remaining_stock(product.available_stock_trigal,1) 
        compromise_remaining_stock(product.available_stock_polo,2)     
    end
    
  end
  
  
  def compromise_remaining_stock(stock_from_store,store_id)
        stock_from_store = 0 if stock_from_store.nil?
        product = self.product.reload
        
        if self.pending <= stock_from_store and not self.pending.zero?  # si con el stock de carisa se cubre..

            #self.product.update_stock(-self.pending)                    # se quita el stock del total
            #self.product.update_store_stock(-self.pending,store_id)            #disminuye el stock de tienda
            update_compromise_from_store(self.pending,store_id)                    # se registra que se extrajo de tienda todo
            product.update_available_stock(store_id,self.pending)
            self.pending = 0                                             # se indica que ya no falta nada más

        elsif self.pending > stock_from_store                            # si no se cubre, se descarga lo que se pueda
            #self.product.update_stock(-stock_from_store)                 # todo lo que habia de la tienda
            #self.product.update_store_stock(-stock_from_store,store_id)
            update_compromise_from_store(stock_from_store,store_id)                 # se registra lo que se sacó
            self.pending -= stock_from_store                             # y disminuyo lo que falta
            product.update_available_stock(store_id,stock_from_store)
            
        end

        #self.save
    
  end
  
  def unload_from_store(stock_from_store,store_id)
  
      stock_from_store = 0 if stock_from_store.nil?
      pending = self.pending
      product = self.product.reload
      
      if self.pending <= stock_from_store and not self.pending.zero?  # si con el stock de carisa se cubre..

          product.update_stock(-self.pending)                    # se quita el stock del total
          product.update_store_stock(-self.pending,store_id)            #disminuye el stock de tienda
          update_from_store(self.pending,store_id)                    # se registra que se extrajo de tienda todo
          self.pending = 0                                             # se indica que ya no falta nada más
          pending = self.pending
      elsif self.pending > stock_from_store                            # si no se cubre, se descarga lo que se pueda
          product.update_stock(-stock_from_store)                 # todo lo que habia de la tienda
          product.update_store_stock(-stock_from_store,store_id)
          update_from_store(stock_from_store,store_id)                 # se registra lo que se sacó
          self.pending -= stock_from_store                             # y disminuyo lo que falta
          pending = self.pending
          check_remaining_stores(store_id)
      end

      self.pending = pending if pending != self.pending
    
  end
  
  def return_stock

    product = self.product.reload    
    product.update_stock(self.quantity-self.pending)
    
    case self.quote.store_id 
      when 1
        product.update_store_stock(self.stock_from_trigal,1)      
      when 2
        product.update_store_stock(self.stock_from_polo,2)        
      when 3
        product.update_store_stock(self.stock_from_almacen,3)
      when 5
        product.update_store_stock(self.stock_from_carisa,5)     
    end
    
    product.update_available_stock(1,self.stock_trigal_compromised)
    product.update_available_stock(2,self.stock_polo_compromised)
    product.update_available_stock(3,self.stock_almacen_compromised)
    product.update_available_stock(5,self.stock_carisa_compromised)            
    self.stock_from_trigal = 0
    self.stock_from_polo = 0        
    self.stock_from_almacen = 0        
    self.stock_from_carisa = 0
    self.stock_trigal_compromised = 0
    self.stock_polo_compromised = 0
    self.stock_almacen_compromised = 0
    self.stock_carisa_compromised = 0
    self.save
    
  end
  
  
  def unload_stock_from_stores    
=begin  
    #sacar de almacen
     unload_from_store(self.product.stock_almacen,3) 
     #sacar de carisa
     unload_from_store(self.product.stock_clarisa,5) 
     #sacar de trigal
     unload_from_store(self.product.stock_trigal,1) 
     #sacar de polo
     unload_from_store(self.product.stock_polo,2)     
=end

    product = self.product.reload
     case self.quote.store_id
        when 1 # trigal
          unload_from_store(product.available_stock_trigal,1) 
        when 2 # polo
          unload_from_store(product.available_stock_polo,2)     
        when 3 #almacen
          unload_from_store(product.available_stock_almacen,3) 
        when 5 #carisa
          unload_from_store(product.available_stock_carisa,5) 
        end

  end

  def unload_stock  
    
    self.pending = self.quantity   # el stock que necesitamos cubrir
    self.stock_from_trigal = 0
    self.stock_from_polo = 0        
    self.stock_from_almacen = 0        
    self.stock_from_carisa = 0
    self.stock_trigal_compromised = 0
    self.stock_polo_compromised = 0
    self.stock_almacen_compromised = 0
    self.stock_carisa_compromised = 0
    self.save
    
    unload_stock_from_stores
    
    self.save
    
  end
  
  def continue_unload_stock
    
    unload_stock_from_stores
    
    #unload_from_store()

      self.save
    
  end
  
  
end
