# == Schema Information
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

require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
