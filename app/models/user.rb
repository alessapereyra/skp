# == Schema Information
# Schema version: 20081204141634
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  username   :string(255)
#  email      :string(255)
#  role_id    :integer(4)
#  password   :string(255)
#  store_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  
  belongs_to :role
  belongs_to :store
  
  validates_presence_of :username, :message => "requiere un valor"
  validates_presence_of :password, :message => 'requiere un valor'
  
  def storage?
    self.username == "almacen"
  end
  
  def admin?
    self.role_id == 1
  end

  def store_supervisor?
    self.role_id == 5 #supervisor
  end

  def salesclerk?
    self.role_id == 2
  end
  
  def store_admin?
    self.role_id == 3
  end
  
  def store?
    self.role_id == 4
  end
  
end
