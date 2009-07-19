# == Schema Information
#
# Table name: exit_orders
#
#  id           :integer(4)      not null, primary key
#  store_id     :integer(4)
#  client_id    :integer(4)
#  sending_date :datetime
#  driver_name  :string(255)
#  driver_dni   :string(255)
#  extra_data   :text
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)
#  document     :string(255)
#  unload_stock :boolean(1)
#  address      :string(255)
#  price        :decimal(10, 2)
#

require 'test_helper'

class ExitOrderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
