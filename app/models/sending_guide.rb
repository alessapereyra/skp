# == Schema Information
#
# Table name: sending_guides
#
#  id                :integer(4)      not null, primary key
#  store_id          :integer(4)
#  client_id         :integer(4)
#  sending_date      :datetime
#  driver_name       :string(255)
#  license_plate     :string(255)
#  truck_description :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  document          :string(255)
#  status            :string(255)
#  delivery_address  :string(255)
#  delivery_contact  :string(255)
#  delivery_phone    :string(255)
#  unload_stock      :boolean(1)
#  sending_type      :string(255)
#

class SendingGuide < ActiveRecord::Base

  belongs_to :store
  belongs_to :client
  belongs_to :provider
  
  has_many :sending_guide_details
  has_many :orders
  has_many :products, :through => :sending_guide_details
  
  validates_associated :store
  validates_associated :client

  
  named_scope :pending, :conditions=>{:status => "pending"}
  named_scope :returned, :conditions=>{:status => "returned"}  
  named_scope :accepted, :conditions=>"sending_guides.status like 'accepted' and (unload_stock is true or unload_stock is null)"
  named_scope :unloaded, :conditions =>"unload_stock is false" 
  
  
  SendingTypes = [
    "",
   "perdida",
   "mal-estado",
   "consumo-interno",
   "consumo-externo",
   "devolucion"]
  
  
  def providers
    
    @providers = Provider.all(:select=>"providers.id,providers.name",:joins=>{:input_orders=> {:input_order_details=>{:product=>:sending_guide_details}}},:conditions=>["sending_guide_id = ?",self.id], :group=>:name)
  end
  
  def complete?
    status == "complete"
  end
  
  def returned?
    status == "returned"
  end
  
  def no_type?
    self.sending_type == ""
  end
  

end
