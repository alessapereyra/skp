# == Schema Information
# Schema version: 20081204141634
#
# Table name: units
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  equivalent_unit_id :integer(8)
#  equivalence        :integer(8)
#  created_at         :datetime
#  updated_at         :datetime
#

class Unit < ActiveRecord::Base
  
  has_many :products
  
  validates_presence_of :name, :on => :create, :message => "no puede ser vacío"
  validates_numericality_of :equivalent_unit_id, :on => :create, :message => "no es un número", :if => lambda{!:equivalent_unit_id.blank?}
  validates_numericality_of :equivalence, :on => :create, :message => "no es un número", :if => lambda{!:equivalence.blank?}
  
  
end
