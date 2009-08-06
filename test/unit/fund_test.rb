# == Schema Information
#
# Table name: funds
#
#  id             :integer(4)      not null, primary key
#  store_id       :integer(4)
#  registry_date  :datetime
#  net_income     :decimal(10, 2)
#  decimal        :decimal(10, 2)
#  widthdrawal    :decimal(10, 2)
#  cash_amount    :decimal(10, 2)
#  created_at     :datetime
#  updated_at     :datetime
#  expenses       :decimal(10, 2)
#  earnings       :decimal(10, 2)
#  yesterday_fund :integer(4)
#

require 'test_helper'

class FundTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
