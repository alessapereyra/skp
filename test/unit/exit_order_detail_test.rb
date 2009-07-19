# == Schema Information
#
# Table name: exit_order_details
#
#  id            :integer(4)      not null, primary key
#  exit_order_id :integer(4)
#  product_id    :integer(4)
#  price         :decimal(10, 2)
#  created_at    :datetime
#  updated_at    :datetime
#  status        :integer(4)
#  discount      :integer(4)
#  quantity      :decimal(10, 2)
#

require 'test_helper'

class ExitOrderDetailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
