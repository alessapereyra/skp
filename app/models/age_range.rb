# == Schema Information
# Schema version: 20081204141634
#
# Table name: age_ranges
#
#  id         :integer(4)      not null, primary key
#  quote_id   :integer(4)
#  age_from   :integer(4)
#  age_to     :integer(4)
#  femenine   :integer(4)
#  masculine  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  version    :integer(4)
#  from_web   :boolean(1)
#

class AgeRange < ActiveRecord::Base

belongs_to :quote

acts_as_versioned

def version_condition_met? 
    self.from_web || self.from_web.blank?
end


end
