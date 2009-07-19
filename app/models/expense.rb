# == Schema Information
# Schema version: 20081204141634
#
# Table name: expenses
#
#  id           :integer(4)      not null, primary key
#  amount       :decimal(10, 2)
#  description  :string(255)
#  expense_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  store_id     :integer(4)
#

class Expense < ActiveRecord::Base
end
