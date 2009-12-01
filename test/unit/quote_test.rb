# == Schema Information
#
# Table name: quotes
#
#  id                       :integer(4)      not null, primary key
#  client_id                :integer(4)
#  store_id                 :integer(4)
#  user_id                  :integer(4)
#  client_address           :string(255)
#  quote_date               :datetime
#  duration                 :integer(4)
#  sending_details          :string(255)
#  quote_comments           :text
#  created_at               :datetime
#  updated_at               :datetime
#  document                 :string(255)
#  status                   :string(255)
#  contact_name             :string(255)
#  price_type               :string(255)
#  updated                  :boolean(1)
#  sent                     :boolean(1)
#  child_number             :integer(4)
#  budget                   :decimal(10, 2)
#  is_requested             :boolean(1)
#  orders_generated         :boolean(1)
#  quote_details_count      :integer(4)      default(0)
#  from_web                 :boolean(1)
#  request_date             :date
#  delivered_date           :datetime
#  sending_guides_generated :boolean(1)
#

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
