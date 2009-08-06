# == Schema Information
# Schema version: 20090320214122
#
# Table name: input_orders
#
#  id           :integer(4)      not null, primary key
#  provider_id  :integer(8)
#  cost         :decimal(10, 2)
#  order_date   :datetime
#  type         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  store_id     :integer(8)
#  owner_id     :integer(8)
#  buying_date  :date
#  code         :string(255)
#  status       :string(255)
#  document     :string(255)
#  unload_stock :boolean(1)
#  input_type   :string(255)
#

class InputOrder < ActiveRecord::Base
  
  belongs_to :provider
  belongs_to :store
  belongs_to :owner, :class_name => "Store", :foreign_key => "owner_id"
  has_many :input_order_details
  has_many :products, :through => :input_order_details

  validates_numericality_of :cost, :on => :create, :message => "no es un múmero"
  validates_numericality_of :provider_id, :on => :create
  validates_numericality_of :owner_id, :on => :create, :message => "no es un número"
  validates_associated :provider
  validates_associated :store
  
  named_scope :pending, :conditions=>{:status => "pendiente"}
  named_scope :accepted, :conditions=>{:status => "terminada"} 
  
  InputTypes = [
    "",
   "compras",
   "inventario",
   "devoluciones"]
  
  
  def childless?
    self.input_order_details.empty?
  end
  
  #validación del resto de atributos
  def recalculate_cost
    self.cost = self.input_order_details.inject(0){| sum, iod | sum + (iod.cost.to_f*iod.quantity)  }
    self.save!
  end
  
  def of_category?(category_id)
  
      self.products.any?{|p| p.category_id == category_id }
    
  end
  
  def of_provider?(provider_id)
    self.provider_id == provider_id
  end
  
  
  
  def restore

    if status == "terminada"
      
      self.input_order_details.each do |iod|
        
          unless iod.product.nil?

            if self.unload_stock or self.unload_stock.nil?
              iod.product.update_stock(-iod.quantity)
              iod.product.update_store_stock(-iod.quantity, self.store_id,self.class,this_method_name)
              iod.product.status = "open"
              iod.product.save!

              #iod.product.unload_if_pending
              #iod.product.save!
            end
          end  #no es nulo
        
      end #each do
       
    end #terminada

  end
 
  
end
