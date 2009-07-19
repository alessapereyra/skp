# == Schema Information
# Schema version: 20081204141634
#
# Table name: brands
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Brand < ActiveRecord::Base

  has_many :products

end
