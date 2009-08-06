# == Schema Information
#
# Table name: product_logs
#
#  id                 :integer(4)      not null, primary key
#  product_logs_id    :integer(4)
#  product_id         :integer(4)
#  controller         :string(255)
#  method             :string(255)
#  last_stock         :decimal(10, 2)
#  last_stock_trigal  :decimal(10, 2)
#  last_stock_polo    :decimal(10, 2)
#  last_stock_almacen :decimal(10, 2)
#  last_stock_clarisa :decimal(10, 2)
#  stock              :decimal(10, 2)
#  stock_trigal       :decimal(10, 2)
#  stock_polo         :decimal(10, 2)
#  stock_almacen      :decimal(10, 2)
#  stock_clarisa      :decimal(10, 2)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class ProductLogTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
