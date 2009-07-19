# == Schema Information
# Schema version: 20081204141634
#
# Table name: categories
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  category_id :integer(8)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Category < ActiveRecord::Base
  
  has_many :categories, :class_name => "Category", :foreign_key => "category_id"
  belongs_to :product
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "category_id"
  
  validates_presence_of :name, :on => :create, :message => "no puede estar vacío"
  validates_numericality_of :category_id, :on => :create, :message => "no es un número", :allow_nil=>true
  
  def complete
    
    self.name + "  -  " + self.description
    
  end
end
