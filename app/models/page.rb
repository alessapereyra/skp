# == Schema Information
# Schema version: 20090320214122
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  content    :text
#  order      :integer(8)
#  parent_id  :integer(8)
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base

has_many :subpages, :class_name => "Page", :foreign_key => "parent_id"
belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"

end
