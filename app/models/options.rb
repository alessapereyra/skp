# == Schema Information
# Schema version: 20081204141634
#
# Table name: options
#
#  id            :integer(4)      not null, primary key
#  current_store :integer(4)
#  igv           :float
#  created_at    :datetime
#  updated_at    :datetime
#

class Options < ActiveRecord::Base

  def self.GetCurrentStore
  
  #  Options.first.current_store
    
    
  
    
  end
  
  def self.SetCurrentStore(store_id)
  #  opt = Options.first
  # opt.current_store = store_id
  #  opt.save!
    
  end

end
