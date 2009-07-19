# == Schema Information
#
# Table name: quote_details
#
#  id                        :integer(4)      not null, primary key
#  quote_id                  :integer(4)
#  product_id                :integer(4)
#  quantity                  :integer(4)
#  product_detail            :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  from                      :integer(4)
#  to                        :integer(4)
#  age_from                  :integer(4)
#  age_to                    :integer(4)
#  price                     :decimal(10, 2)
#  version                   :integer(4)
#  from_web                  :boolean(1)
#  additional                :boolean(1)
#  sex                       :string(255)
#  pending                   :integer(4)
#  stock_from_almacen        :integer(4)
#  stock_from_carisa         :integer(4)
#  stock_from_trigal         :integer(4)
#  stock_from_polo           :integer(4)
#  unavailable               :boolean(1)
#  stock_trigal_compromised  :integer(4)      default(0)
#  stock_polo_compromised    :integer(4)      default(0)
#  stock_almacen_compromised :integer(4)      default(0)
#  stock_carisa_compromised  :integer(4)      default(0)
#  pack_number               :integer(4)
#  months                    :boolean(1)
#

require 'test_helper'

class QuoteDetailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
